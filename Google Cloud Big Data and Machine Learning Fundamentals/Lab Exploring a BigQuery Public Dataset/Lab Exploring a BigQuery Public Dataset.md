# Exploring a BigQuery Public Dataset

## Overview

Storing and querying massive datasets can be time consuming and expensive without the right hardware and infrastructure. BigQuery is an enterprise data warehouse that solves this problem by enabling super-fast SQL queries using the processing power of Google's infrastructure. Simply move your data into BigQuery and let us handle the hard work. You can control access to both the project and your data based on your business needs, such as giving others the ability to view or query your data.

You access BigQuery through the Cloud Console, the command-line tool, or by making calls to the BigQuery REST API using a variety of client libraries such as Java, .NET, or Python. There are also a variety of third-party tools that you can use to interact with BigQuery, such as visualizing the data or loading the data. In this lab, you access BigQuery using the web UI.

You can use the BigQuery web UI in the Cloud Console as a visual interface to complete tasks like running queries, loading data, and exporting data. This hands-on lab shows you how to query tables in a public dataset and how to load sample data into BigQuery through the Cloud Console.

### Objectives

In this lab, you learn how to perform the following tasks:

- Query a public dataset

- Create a custom table

- Load data into a table

- Query a table

## Task 1. Query a public dataset

In this task, you load a public dataset, USA Names, into BigQuery, then query the dataset to determine the most common names in the US between 1910 and 2013.

### Load the USA Names dataset

#### 1 - In the left pane, click ADD DATA > Explore public datasets.

![ADD DATA](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/1_add_data.png?raw=true)

#### 2 - In the searchbox, type USA Names then press ENTER.

#### 3 - Click on the USA Names tile you see in the search results.

![USA Names](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/3_select_dataset.png?raw=true)

#### 4 - Click View dataset.

![View Dataset](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/4_select_dataset_usa_names.png?raw=true)

### Query the USA Names dataset

Query 'bigquery-public-data.usa_names.usa_1910_2013' for the name and gender of the babies in this dataset, and then list the top 10 names in descending order.

#### 1 - Copy and paste the following query into the Query editor text area:

```
SELECT
  name, gender,
  SUM(number) AS total
FROM
  `bigquery-public-data.usa_names.usa_1910_2013`
GROUP BY
  name, gender
ORDER BY
  total DESC
LIMIT
  10
```

#### 2 - In the upper right of the window, view the query validator.

![View Validator](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/2_2_view_validator.png?raw=true)

#### 3 - Click Run.

![RUM](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/2_3_click_RUM.png?raw=true)

## Task 2. Create a custom table

In this task, you create a custom table, load data into it, and then run a query against the table.

### Download the data to your local computer

The file you're downloading contains approximately 7 MB of data about popular baby names, and it is provided by the US Social Security Administration.

#### 1 - Download the [baby names zip file](https://www.ssa.gov/OACT/babynames/names.zip) to your local computer.

#### 2 - Unzip the file onto your computer.

#### 3 - The zip file contains a NationalReadMe.pdf file that describes the dataset. [Learn more about the dataset](https://www.ssa.gov/OACT/babynames/background.html).

#### 4 - Open the file named yob2014.txt to see what the data looks like. The file is a comma-separated value (CSV) file with the following three columns: name, sex (M or F), and number of children with that name. The file has no header row.

#### 5 - Note the location of the yob2014.txt file so that you can find it later.

## Task 3. Create a dataset

In this task, you create a dataset to hold your table, add data to your project, then make the data table you'll query against.

Datasets help you control access to tables and views in a project. This lab uses only one table, but you still need a dataset to hold the table.

#### 1 - Back in the Cloud Console, in the left pane, in the Explorer section, click your Project ID (it will start with qwiklabs).

![EXPLORER](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/3_1_explorer.png?raw=true)

#### 2 - Click on the three dots next to your project ID and then click Create dataset.

![CREATE DATASET](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/3_2_create_dataset.png?raw=true)

#### 3 - On the Create dataset page:

  - For Dataset ID, enter babynames.
  - For Data location, choose us (multiple regions in United States).
  - For Default table expiration, leave the default value.
  - For Encryption, leave the default value.
    
#### 4 - Click Create dataset at the bottom of the pane.

## Task 4. Load the data into a new table

In this task, you load data into the table you made.

#### 1 - Click on the three dots next to babynames found in the left pane in the Explorer section, and then click Create table.

Use the default values for all settings unless otherwise indicated.

#### 2 - On the Create table page:

  - For Source, choose Upload from the Create table from: dropdown menu.
  - For Select file, click Browse, navigate to the yob2014.txt file and click Open.
  - For File format, choose CSV from the dropdown menu.
  - For Table name, enter names_2014.
  - In the Schema section, click the Edit as text toggle and paste the following schema definition in the text box.

    ```
    name:string,gender:string,count:integer

    ```
#### 3 - Click Create table (at the bottom of the window).

### Preview the table

#### 1 - In the left pane, select babynames > names_2014 in the navigation pane.

#### 2 - In the details pane, click the Preview tab.

![View Table](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/4_2_preview_table.png?raw=true)

## Task 5. Query the table

Now that you've loaded data into your table, you can run queries against it. The process is identical to the previous example, except that this time, you're querying your table instead of a public table.

#### 1 - In the Query editor, click Compose new query.

#### 2 - Copy and paste the following query into the Query editor. This query retrieves the top 5 baby names for US males in 2014.

```
    SELECT
 name, count
FROM
 babynames.names_2014
WHERE
 gender = 'M'
ORDER BY count DESC LIMIT 5

```

#### 3 - Click Run. The results are displayed below the query window.

![Query Results](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20Exploring%20a%20BigQuery%20Public%20Dataset/images/5_3_run.png?raw=true)

---

# finished lab