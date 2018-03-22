# -*- coding: utf-8 -*-
from celery import Celery
from config import CONFIG
import logging

celery = Celery('tasks_two', broker=CONFIG['CELERY_BROKER_URL'])
celery.conf.update(CONFIG)

@celery.task()
def send_async_email_by_tasks_two(email_msg):
  ''' send async email (tasks_two) '''
  logging.info('send async email (tasks_two)')

@celery.task()
def do_async_task_by_tasks_two(task_msg):
  ''' do async task '''
  logging.info('do async task (tasks_two)')