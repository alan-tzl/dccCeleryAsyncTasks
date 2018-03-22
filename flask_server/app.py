# -*- coding: utf-8 -*-
from flask import Flask, request, Response
import json
from config import CONFIG
import tasks_one
import tasks_two

from celery import Celery

app = Flask(__name__)
app.config['CELERY_BROKER_URL'] = CONFIG['CELERY_BROKER_URL']
app.config['CELERY_RESULT_BACKEND'] = CONFIG['CELERY_RESULT_BACKEND']
app.config['CELERY_ROUTES'] = CONFIG['CELERY_ROUTES']

celery = Celery(app.name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(CONFIG)

@app.route('/')
def default():
    msg ={'hello': 'flask server'}
    celery.send_task('tasks_one.send_async_email_by_tasks_one', args=[json.dumps(msg)])
    celery.send_task('tasks_one.do_async_task_by_tasks_one', args=[json.dumps(msg)])
    celery.send_task('tasks_two.send_async_email_by_tasks_two', args=[json.dumps(msg)])
    celery.send_task('tasks_two.do_async_task_by_tasks_two', args=[json.dumps(msg)])
    return 'Dockerized Flask App...'

@app.route('/tasks-one')
def task_one():
    msg ={'hello': 'tasks-one'}
    
    celery.send_task('tasks_one.send_async_email_by_tasks_one', args=[json.dumps(msg)])
    celery.send_task('tasks_one.do_async_task_by_tasks_one', args=[json.dumps(msg)])
    return 'Dockerized Flask App...'

@app.route('/tasks-two')
def task_two():
    msg ={'hello': 'tasks-two'}
    celery.send_task('tasks_two.send_async_email_by_tasks_two', args=[json.dumps(msg)])
    celery.send_task('tasks_two.do_async_task_by_tasks_two', args=[json.dumps(msg)])
    return 'Dockerized Flask App...'

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0',port=8080)