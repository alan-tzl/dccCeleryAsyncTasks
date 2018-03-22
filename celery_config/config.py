# -*- coding: utf-8 -*-
CONFIG = {
  'CELERY_BROKER_URL': 'redis://172.99.0.2:6379/0',
  'CELERY_RESULT_BACKEND': 'redis://172.99.0.2:6379/0',
  'CELERY_ROUTES': {
    'tasks_one.send_async_email_by_tasks_one': {
      'queue': 'tasks_one_queue1'
    },
    'tasks_one.do_async_task_by_tasks_one': {
      'queue': 'tasks_one_queue2'
    },
    'tasks_two.send_async_email_by_tasks_two': {
      'queue': 'tasks_two_queue1'
    },
    'tasks_two.do_async_task_by_tasks_two': {
      'queue': 'tasks_two_queue2'
    }
  }
}