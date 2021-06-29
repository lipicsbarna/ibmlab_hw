import streamlit as st
from db_utils import Maria
import pandas as pd

st.title("MariaDB UFO indexing")

st.header("Table schema")
schema = """
 CREATE TABLE ufos (
  date_time datetime DEFAULT NULL,
  city text DEFAULT NULL, 
  state text DEFAULT NULL, 
  country varchar(2) DEFAULT NULL, 
  shape varchar(9) DEFAULT NULL, 
  duration_sec bigint(20) DEFAULT NULL, 
  duration_str text DEFAULT NULL, 
  comments text DEFAULT NULL, 
  date_posted text DEFAULT NULL, 
  latitude text DEFAULT NULL, 
  longitude text DEFAULT NULL, 
  KEY shape_country_idx (shape,country), 
  KEY shape_country_date_idx (shape,country,date_time), 
  KEY shape_idx (shape), 
  KEY country_idx (country), 
  KEY date_time_idx (date_time) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
"""
st.code(schema, language='sql')


st.header("Filtering, sorting")
st.subheader('Count of shapes')
maria = Maria()
indexes = ['date_time', 'country', 'shape']

count_df_sql = "explain select shape, count(1) from ufos group by shape"
st.code(count_df_sql, language='sql')
st.dataframe(data=maria.sql(count_df_sql))
if(st.button("Get shapes by number of sights")):
	st.dataframe(data=maria.sql("select shape, count(1) from ufos group by shape"))

st.subheader('Specify filter conditions')
st.write("fill conditions as you would complete the SQL query, e.g.:")
st.write("Example column")
st.code("='example value'")
st.write('or you can use comparison operators as well')
st.write("Example date_time column")
st.code("between '1954-01-04' and '1987-11-16'")

st.subheader("...and now choose your filters from the list")
chosen_indexes = st.multiselect("Filters:", indexes)
if len(chosen_indexes) > 0:
	st.write(f"You chose these {', '.join(chosen_indexes)}")

conditions = dict()
for index in chosen_indexes:
	_value = st.text_input(index, '=')
	conditions.update({index: _value })
st.write("If you would like to, feel free to add free where condition here:")
free_condition = st.text_input("your free condition", '')
if free_condition is not None and free_condition != '':
	conditions.update({'free_condition': free_condition})
st.write(conditions)


sql_start = "select * from ufos where 1 = 1"
sql = sql_start
if len(conditions) == 0:
	st.write("You haven't specified a where condition")
	st.write(sql_start)
else:
	where_conditions = [str(key) + str(value) for key,value in conditions.items() if key != 'free_condition']
	if 'free_condition' in conditions.keys():
		where_conditions.append(f"{conditions.get('free_condition')}")
	sql = sql_start
	sql += " and "
	sql += " and ".join(where_conditions)
	sql = sql.replace("  ", " ")

order_map = {
	'Ascending': 'asc',
	'Descending': 'desc',
	'None': None
}
orderby=None

_orderby = st.radio("Order:", ('None', 'Ascending', 'Descending'))
orderby = order_map.get(_orderby)

if orderby is not None:
	if "order by date_time" in sql:
		if sql[-3:] == 'asc':
			cutback = 3
		else:
			cutback = 4
		sql = sql[:-cutback]
	else:
		sql += f" order by date_time {orderby}"

else:
	if "order by date_time" in sql:
		sql.split("order by date_time")[0]
st.write(sql)



if(st.button("Get query plan")):
	st.write(("explain extended " + sql))
	query_plan_df = maria.sql(("explain extended " + sql))
	st.dataframe(data=query_plan_df)
	st.write("Extra:")
	st.write(query_plan_df['Extra'].values[0])

if(st.button("Get example data")):
	st.dataframe(data=maria.sql((sql + " limit 15")))



maria.dispose()