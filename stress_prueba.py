import threading
import time
import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv

load_dotenv()

# Configuración de la prueba
CONEXIONES_SIMULTANEAS = 100
ventas_exitosas = 0
ventas_fallidas = 0

def simular_venta_rapida(hilo_id):
    global ventas_exitosas, ventas_fallidas
    
    try:
        # Cada hilo abre su propia conexión para saturar el pool de MySQL
        conexion = mysql.connector.connect(
            host=os.getenv("DB_HOST"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS"),
            database=os.getenv("DB_NAME")
        )
        cursor = conexion.cursor()
        conexion.start_transaction()

        # Insertar un pedido rápido (Hardcodeado para la prueba)
        cursor.execute("INSERT INTO pedidos (id_personal, id_tipo_pago, total) VALUES (1, 1, 150.00)")
        id_pedido = cursor.lastrowid
        cursor.execute("INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario) VALUES (%s, 1, 2, 75.00)", (id_pedido,))
        
        conexion.commit()
        ventas_exitosas += 1

    except Error as e:
        ventas_fallidas += 1
        # print(f"Hilo {hilo_id} falló: {e}") # Descomentar para ver el error exacto (ej. "Too many connections")
    finally:
        if 'conexion' in locals() and conexion.is_connected():
            cursor.close()
            conexion.close()

print(f"Iniciando prueba de estrés con {CONEXIONES_SIMULTANEAS} transacciones simultáneas...")
inicio = time.time()

hilos = []
for i in range(CONEXIONES_SIMULTANEAS):
    hilo = threading.Thread(target=simular_venta_rapida, args=(i,))
    hilos.append(hilo)
    hilo.start()

# Esperar a que todos los hilos terminen
for hilo in hilos:
    hilo.join()

fin = time.time()

print("--- RESULTADOS DE LA PRUEBA ---")
print(f"Tiempo total: {fin - inicio:.2f} segundos")
print(f"Ventas Exitosas: {ventas_exitosas}")
print(f"Ventas Fallidas (Conexiones rechazadas o Timeouts): {ventas_fallidas}")