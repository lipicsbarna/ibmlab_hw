import mariadb
import pandas as pd
from sqlalchemy import create_engine


class Maria():

	def __init__(self):
		self.engine = create_engine('mariadb+mariadbconnector://root:my-secret-pw@localhost:3306/ufo')

	def sql(self,sql):
		return pd.read_sql(sql, self.engine)

	def dispose(self):
		self.engine.dispose()

	def __del__(self):
		self.dispose()

