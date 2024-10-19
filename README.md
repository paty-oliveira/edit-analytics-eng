# Analytics Engineering Module

### How to start

1. Create Python virtual environment:

```
    make create-venv
```

2. Activate your Python virtual enviroment:

```
    source ./venv/bin/activate
```

3. Initialise PostgresSQL database. Make sure you have Docker running on your machine:

```
    make setup-postgres-db
```

4. Check the database connection:

```
    make dbt-debug
```