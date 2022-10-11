#!/usr/bin/env python
import pika
import sys

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))

channel = connection.channel()
channel.exchange_declare(exchange='direct_logs', exchange_type='direct')

routing_key = 'info'
body = 'new string message!'

channel.basic_publish(exchange='direct_logs', routing_key=routing_key, body=body)

print(" [x] Sent %r:%r" % (routing_key, body))
connection.close()