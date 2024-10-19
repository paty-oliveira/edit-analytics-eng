# Analytics Engineering Module

## Setup the environment
In the folder `starbucks_dw`, run the following commands:

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

## Load data sources

The data sources of this project are three CSV files about Starbucks Customer Data from [Kaggle](https://www.kaggle.com/datasets/ihormuliar/starbucks-customer-data/).

This data was provided by Starbucks to simulate their customers and transactions to identify if there are
better approaches to sending customers promotional deals.

The data sources for this project are available on `seeds/` folder and they will be ingested as a [seeds](https://docs.getdbt.com/docs/build/seeds).

- `portfolio.csv`: Information about the promotional offers that are possible to receive, and basic information about each one.
- `profile.csv`: Information about the customers that are part of the promotional offers program.
- `transcript.csv`: Information about the different steps of promotional offers that a customer receives. It also contains information about the transactions that the customer makes.

To load these files on the PostgresSQL database running on the docker container, run the following command:

```
    make dbt-seed
```

These threee data sources are now loaded on `raw` schema. Check the `dbt_project.yml` file to see where the schema configuration has been configured.
