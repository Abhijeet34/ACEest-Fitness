import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-key-please-change'
    DATABASE = os.environ.get('DATABASE_URL') or os.path.join(os.getcwd(), 'instance', 'aceest_fitness.sqlite')
