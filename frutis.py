import os
import tkinter as tk
from tkinter import messagebox, simpledialog, ttk
import mysql.connector
from mysql.connector import Error
from dotenv import load_dotenv

# Cargar configuración desde el archivo .env
load_dotenv()

# ==========================================
# CONEXIÓN A BASE DE DATOS
# ==========================================
def get_db_connection():
    try:
        conexion = mysql.connector.connect(
            host=os.getenv("DB_HOST"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS"),
            database=os.getenv("DB_NAME")
        )
        return conexion
    except Error as e:
        messagebox.showerror("Error de Conexión", f"No se pudo conectar a MySQL:\n{e}")
        return None

# ==========================================
# FUNCIONES DE INICIO Y CARGA
# ==========================================
def login_empleado():
    user = simpledialog.askstring("Login", "Usuario:")
    password = simpledialog.askstring("Login", "Contraseña:", show="*")
    
    if not user or not password:
        return None, None, None

    conexion = get_db_connection()
    if not conexion:
        return None, None, None

    try:
        cursor = conexion.cursor(dictionary=True)
        # Verificamos credenciales reales
        query = "SELECT id_personal, nombre, rol FROM personal WHERE usuario = %s AND password = %s"
        cursor.execute(query, (user, password))
        resultado = cursor.fetchone()

        if resultado:
            return resultado["id_personal"], resultado["nombre"], resultado["rol"]
        else:
            messagebox.showerror("Error", "Credenciales incorrectas")
            return None, None, None
            
    except Error as e:
        messagebox.showerror("Error SQL", f"Error al iniciar sesión:\n{e}")
        return None, None, None
    finally:
        if conexion.is_connected():
            cursor.close()
            conexion.close()

def cargar_catalogo():
    catalogo.clear()
    tabla.delete(*tabla.get_children())

    conexion = get_db_connection()
    if not conexion:
        return

    try:
        cursor = conexion.cursor(dictionary=True)
        # Cargar productos
        cursor.execute("SELECT id_producto, nombre, unidad_medida, precio_venta, costo_compra FROM productos")
        productos_db = cursor.fetchall()

        for prod in productos_db:
            nombre = prod["nombre"]
            unidad = prod["unidad_medida"]
            precio = float(prod["precio_venta"])
            id_prod = prod["id_producto"]
            costo = float(prod["costo_compra"])

            catalogo[nombre] = {"id": id_prod, "unidad": unidad, "precio": precio, "costo": costo}
            tabla.insert("", "end", values=(nombre, unidad, f"$ {precio:.2f}"))

        productos_combo["values"] = sorted(catalogo.keys())
        if not producto_var.get() and productos_combo["values"]:
            producto_var.set(productos_combo["values"][0])
        
        # Cargar tipos de pago
        cursor.execute("SELECT id_tipo_pago, descripcion FROM tipo_pago")
        pagos_db = cursor.fetchall()
        for p in pagos_db:
            tipos_pago[p["descripcion"]] = p["id_tipo_pago"]
            
        if "combo_pago" in globals():
            combo_pago["values"] = list(tipos_pago.keys())
            combo_pago.current(0)

        actualizar_producto()
        estado_var.set(f"Catálogo cargado: {len(productos_db)} productos.")

    except Error as e:
        messagebox.showerror("Error SQL", f"Error al cargar el catálogo:\n{e}")
    finally:
        if conexion.is_connected():
            cursor.close()
            conexion.close()

# ==========================================
# FUNCIONES DE OPERACIÓN (TRANSACCIONES)
# ==========================================
def registrar_venta():
    producto_nombre = producto_var.get()
    cantidad = cantidad_var.get()
    metodo_pago_desc = pago_var.get()
    info = catalogo.get(producto_nombre)

    if not info or not cantidad or not metodo_pago_desc:
        messagebox.showwarning("Aviso", "Llene todos los campos (Producto, Cantidad, Método de Pago)")
        return

    try:
        cantidad = float(cantidad)
        if cantidad <= 0: raise ValueError
    except ValueError:
        messagebox.showerror("Error", "La cantidad debe ser un número mayor a 0.")
        return

    total = cantidad * info["precio"]
    id_producto = info["id"]
    id_pago = tipos_pago[metodo_pago_desc]

    conexion = get_db_connection()
    if not conexion: return

    try:
        cursor = conexion.cursor()
        conexion.start_transaction()

        # 1. Registrar el pedido
        query_pedido = "INSERT INTO pedidos (id_personal, id_tipo_pago, total) VALUES (%s, %s, %s)"
        cursor.execute(query_pedido, (ID_EMP, id_pago, total))
        id_pedido = cursor.lastrowid

        # 2. Registrar el detalle
        query_detalle = "INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario) VALUES (%s, %s, %s, %s)"
        cursor.execute(query_detalle, (id_pedido, id_producto, cantidad, info["precio"]))

        # 3. Descontar del inventario
        query_stock = "UPDATE productos SET stock_actual = stock_actual - %s WHERE id_producto = %s"
        cursor.execute(query_stock, (cantidad, id_producto))

        # 4. Actualizar flujo financiero
        cursor.execute("SELECT saldo_acumulado FROM flujo_financiero ORDER BY id_movimiento DESC LIMIT 1")
        res_saldo = cursor.fetchone()
        saldo_actual = float(res_saldo[0]) if res_saldo else 0.0
        nuevo_saldo = saldo_actual + total

        query_flujo = "INSERT INTO flujo_financiero (tipo, categoria, referencia_id, descripcion, monto, saldo_acumulado) VALUES (%s, %s, %s, %s, %s, %s)"
        cursor.execute(query_flujo, ('INGRESO', 'Venta', id_pedido, f'Venta de {cantidad} {info["unidad"]} {producto_nombre}', total, nuevo_saldo))

        conexion.commit() # Guardar cambios en BD

        estado_var.set(f"Venta registrada. Total: ${total:.2f}")
        messagebox.showinfo("Caja", f"✅ Venta registrada correctamente.\nTotal cobrado: $ {total:.2f}")
        cantidad_var.set("")
        calcular_total()

    except Error as e:
        conexion.rollback() # Si hay error, deshacer todos los cambios
        messagebox.showerror("Error SQL", f"Error al registrar venta:\n{e}")
    finally:
        if conexion.is_connected():
            cursor.close()
            conexion.close()

def registrar_entrada_inventario():
    producto_nombre = producto_var.get()
    cantidad = cantidad_var.get()
    info = catalogo.get(producto_nombre)

    if not info or not cantidad:
        messagebox.showwarning("Aviso", "Llene Producto y Cantidad")
        return

    conexion = get_db_connection()
    if not conexion: return

    try:
        cursor = conexion.cursor()
        # Actualizar stock
        query_stock = "UPDATE productos SET stock_actual = stock_actual + %s WHERE id_producto = %s"
        cursor.execute(query_stock, (float(cantidad), info["id"]))
        conexion.commit()

        estado_var.set("Inventario actualizado.")
        messagebox.showinfo("Almacén", f"📦 Se agregaron {cantidad} {info['unidad']} de {producto_nombre}.")
        cantidad_var.set("")
        
    except Error as e:
        messagebox.showerror("Error SQL", f"Error al actualizar inventario:\n{e}")
    finally:
        if conexion.is_connected():
            cursor.close()
            conexion.close()

def registrar_merma():
    producto_nombre = producto_var.get()
    cantidad = cantidad_var.get()
    info = catalogo.get(producto_nombre)

    if not info or not cantidad:
        messagebox.showwarning("Aviso", "Seleccione el Producto y la Cantidad perdida")
        return

    motivo = simpledialog.askstring("Merma", f"¿Por qué se perdieron {cantidad} de {producto_nombre}?")
    if not motivo: return

    try:
        cantidad = float(cantidad)
        costo_perdida = cantidad * info["costo"]
    except ValueError:
        return

    conexion = get_db_connection()
    if not conexion: return

    try:
        cursor = conexion.cursor()
        conexion.start_transaction()

        # 1. Registrar merma
        query_merma = "INSERT INTO mermas_inventario (id_producto, cantidad, motivo, costo_perdida) VALUES (%s, %s, %s, %s)"
        cursor.execute(query_merma, (info["id"], cantidad, motivo, costo_perdida))
        id_merma = cursor.lastrowid

        # 2. Descontar stock
        query_stock = "UPDATE productos SET stock_actual = stock_actual - %s WHERE id_producto = %s"
        cursor.execute(query_stock, (cantidad, info["id"]))

        # 3. Afectar flujo financiero
        cursor.execute("SELECT saldo_acumulado FROM flujo_financiero ORDER BY id_movimiento DESC LIMIT 1")
        res_saldo = cursor.fetchone()
        saldo_actual = float(res_saldo[0]) if res_saldo else 0.0
        nuevo_saldo = saldo_actual - costo_perdida

        query_flujo = "INSERT INTO flujo_financiero (tipo, categoria, referencia_id, descripcion, monto, saldo_acumulado) VALUES (%s, %s, %s, %s, %s, %s)"
        cursor.execute(query_flujo, ('EGRESO', 'Merma', id_merma, f'Pérdida por {motivo} ({producto_nombre})', costo_perdida, nuevo_saldo))

        conexion.commit()

        estado_var.set("Pérdida registrada.")
        messagebox.showwarning("Merma", f"⚠️ Merma registrada exitosamente.\nImpacto financiero: -$ {costo_perdida:.2f}")
        cantidad_var.set("")

    except Error as e:
        conexion.rollback()
        messagebox.showerror("Error SQL", f"Error al registrar merma:\n{e}")
    finally:
        if conexion.is_connected():
            cursor.close()
            conexion.close()

# ==========================================
# EVENTOS DE INTERFAZ
# ==========================================
def actualizar_producto(*_):
    info = catalogo.get(producto_var.get(), {})
    unidad_var.set(info.get("unidad", "-"))
    precio_var.set(f"{info.get('precio', 0):.2f}")
    calcular_total()

def calcular_total(*_):
    try:
        cantidad = float(cantidad_var.get() or 0)
        precio = float(precio_var.get() or 0)
        total_var.set(f"{cantidad * precio:.2f}")
    except ValueError:
        total_var.set("0.00")

# ==========================================
# INICIO DE LA APLICACIÓN (UI)
# ==========================================
root = tk.Tk()
root.withdraw()

# Variables globales para los datos extraídos
catalogo = {}
tipos_pago = {} 

ID_EMP, NOMBRE_EMP, ROL = login_empleado()
if not ID_EMP:
    raise SystemExit(1)

ventana = tk.Toplevel(root)
ventana.title(f"FRUTIS ERP | Módulo: {ROL.upper()}")
ventana.geometry("1000x650")
ventana.configure(bg="#f5f8fc")
ventana.protocol("WM_DELETE_WINDOW", root.destroy)

# --- Estilos ---
style = ttk.Style(ventana)
style.theme_use("clam")
style.configure("Header.TLabel", font=("Segoe UI", 16, "bold"), background="#f5f8fc")
style.configure("Caja.TLabelframe", background="#e8f4f8") 
style.configure("Inv.TLabelframe", background="#f8f1e8") 

# --- Cabecera ---
header = ttk.Frame(ventana, padding=15)
header.pack(fill="x")
ttk.Label(header, text="Sistema ERP - Sucursal Principal", style="Header.TLabel").pack(anchor="w")
ttk.Label(header, text=f"Usuario: {NOMBRE_EMP} | Nivel de Acceso: {ROL.upper()}").pack(anchor="w")

# --- Contenedor Principal ---
main = ttk.Frame(ventana, padding=15)
main.pack(fill="both", expand=True)
main.columnconfigure(0, weight=1)
main.columnconfigure(1, weight=1)

# --- Panel Izquierdo: Selección ---
panel_izq = ttk.Frame(main)
panel_izq.grid(row=0, column=0, sticky="nsew", padx=(0, 10))

seleccion_frame = ttk.LabelFrame(panel_izq, text="Selección de Producto", padding=10)
seleccion_frame.pack(fill="x", pady=(0, 10))

producto_var = tk.StringVar()
cantidad_var = tk.StringVar()
unidad_var = tk.StringVar(value="-")
precio_var = tk.StringVar(value="0.00")
total_var = tk.StringVar(value="0.00")
pago_var = tk.StringVar()

ttk.Label(seleccion_frame, text="Producto:").grid(row=0, column=0, sticky="w", pady=5)
productos_combo = ttk.Combobox(seleccion_frame, textvariable=producto_var, state="readonly", width=25)
productos_combo.grid(row=0, column=1, sticky="w", padx=10)

ttk.Label(seleccion_frame, text="Cantidad:").grid(row=1, column=0, sticky="w", pady=5)
entry_cantidad = ttk.Entry(seleccion_frame, textvariable=cantidad_var, width=15)
entry_cantidad.grid(row=1, column=1, sticky="w", padx=10)

ttk.Label(seleccion_frame, text="Unidad:").grid(row=2, column=0, sticky="w", pady=5)
ttk.Label(seleccion_frame, textvariable=unidad_var, font=("", 10, "bold")).grid(row=2, column=1, sticky="w", padx=10)

ttk.Label(seleccion_frame, text="Total Estimado:").grid(row=3, column=0, sticky="w", pady=5)
ttk.Label(seleccion_frame, textvariable=total_var, font=("", 12, "bold"), foreground="green").grid(row=3, column=1, sticky="w", padx=10)

# ========================================================
# CONSTRUCCIÓN DINÁMICA BASADA EN EL ROL
# ========================================================

# 1. MÓDULO DE CAJA
if ROL in ["caja", "administrador"]:
    caja_frame = ttk.LabelFrame(panel_izq, text="Operaciones de Caja (Ventas)", padding=10, style="Caja.TLabelframe")
    caja_frame.pack(fill="x", pady=5)
    
    ttk.Label(caja_frame, text="Medio de Pago:").grid(row=0, column=0, sticky="w", pady=5)
    combo_pago = ttk.Combobox(caja_frame, textvariable=pago_var, state="readonly")
    combo_pago.grid(row=0, column=1, padx=10)
    
    ttk.Button(caja_frame, text="💲 Registrar Venta", command=registrar_venta).grid(row=1, column=0, columnspan=2, pady=10, sticky="ew")

# 2. MÓDULO DE INVENTARIO
if ROL in ["inventario", "administrador"]:
    inv_frame = ttk.LabelFrame(panel_izq, text="Operaciones de Almacén (Inventario)", padding=10, style="Inv.TLabelframe")
    inv_frame.pack(fill="x", pady=5)
    
    ttk.Button(inv_frame, text="📦 Ingresar Mercancía", command=registrar_entrada_inventario).grid(row=0, column=0, padx=5, pady=5, sticky="ew")
    ttk.Button(inv_frame, text="⚠️ Registrar Merma / Pérdida", command=registrar_merma).grid(row=0, column=1, padx=5, pady=5, sticky="ew")


# --- Panel Derecho: Catálogo/Vista ---
vista = ttk.LabelFrame(main, text="Catálogo y Precios Actuales", padding=10)
vista.grid(row=0, column=1, sticky="nsew")

tabla = ttk.Treeview(vista, columns=("producto", "unidad", "precio"), show="headings", height=15)
tabla.heading("producto", text="Producto")
tabla.heading("unidad", text="Unidad")
tabla.heading("precio", text="Precio de Venta")
tabla.column("producto", width=150)
tabla.column("unidad", width=70, anchor="center")
tabla.column("precio", width=90, anchor="e")
tabla.pack(fill="both", expand=True)

estado_var = tk.StringVar(value="Esperando operación...")
ttk.Label(ventana, textvariable=estado_var, padding=10, foreground="blue").pack(fill="x")

productos_combo.bind("<<ComboboxSelected>>", actualizar_producto)
entry_cantidad.bind("<KeyRelease>", calcular_total)

cargar_catalogo()
ventana.mainloop()