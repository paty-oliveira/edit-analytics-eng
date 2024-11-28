# Analytics Engineering Module

## How to start
1. Fork this repository and clone it locally. If you're unsure how to fork a repository, check this [tutorial](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo).
2. Set up your local [enviroment](#setup-the-environment).
3. Load the [data sources](#load-data-sources).
4. Solve the exercises provided during the classroom sessions by committing your changes.
5. Once all exercises are completed, create a Pull request to this repository. If you're unsure how to create a pull request from a fork, refer to this [tutorial](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork).
6. Ensure your code passes the automated tests.


## Setup the environment
In the folder `starbucks_dw`, run the following commands:

1. **Create Python virtual environment:**

```
    make create-venv
```

2. **Activate your Python virtual enviroment:**

```
    source ./venv/bin/activate
```

3. **Initialise PostgresSQL database:**

Make sure you have Docker running on your machine:

```
    make setup-postgres-db
```
If you want to use a graphic interface to access PostgreSQL, you can use Adminer. To do this, go to `localhost:8080` and then fill the credentials:

- **Database Engine**: PostgreSQL
- **Server**: postgres
- **User**: dbt
- **Password**: password1
- **Database**: dw_starbucks

4. **Install pre-commit hooks:**

```
    pre-commit install
```

5. **Check the database connection in dbt:**

```
    make dbt-debug
```

## Load data sources

The data sources of this project are three CSV files containing Starbucks Customer Data, available on [Kaggle](https://www.kaggle.com/datasets/ihormuliar/starbucks-customer-data/).

This dataset was provided by Starbucks to simulate customer and transaction data, aiming to explore better approaches for sending promotional deals to customers.

These data sources are located in the `seeds/` folder and  will be ingested as [seeds](https://docs.getdbt.com/docs/build/seeds).

- `portfolio.csv`: Information about the promotional offers that are possible to receive, and basic information about each one.
- `profile.csv`: Information about the customers that are part of the promotional offers program.
- `transcript.csv`: Information about the different steps of promotional offers that a customer receives. It also contains information about the transactions that the customer makes.

To load these files on the PostgresSQL database running in the docker container, run the following command:

```
    make dbt-seed
```

These three data sources will be loaded into the `raw` schema. Refer to the `dbt_project.yml` file to review the schema configuration settings.
