# -*- coding: utf-8 -*-
from celery import Celery
from config import CONFIG
import logging

celery = Celery('tasks_one', broker=CONFIG['CELERY_BROKER_URL'])
celery.conf.update(CONFIG)

@celery.task()
def send_async_email_by_tasks_one(email_msg):
  ''' send async email (tasks_one) '''
  logging.info('send async email (tasks_one)')

@celery.task()
def do_async_task_by_tasks_one(task_msg):
  ''' do async task '''
  logging.info('do async task (tasks_one)')