# Creating a Streaming Data Pipeline for a Real-Time Dashboard with Dataflow

## Overview

In this lab, you own a fleet of New York City taxi cabs and are looking to monitor how well your business is doing in real-time. You will build a streaming data pipeline to capture taxi revenue, passenger count, ride status, and much more and visualize the results in a management dashboard.

## Task 1. Source a public Pub/Sub topic and create a BigQuery dataset

[Pub/Sub](https://cloud.google.com/pubsub/) is an asynchronous global messaging service. By decoupling senders and receivers, it allows for secure and highly available communication between independently written applications. Pub/Sub delivers low-latency, durable messaging.

In Pub/Sub, publisher applications and subscriber applications connect with one another through the use of a shared string called a **topic**. A publisher application creates and sends messages to a topic. Subscriber applications create a subscription to a topic to receive messages from it.

Google maintains a few public Pub/Sub streaming data topics for labs like this one. We'll be using the [NYC Taxi & Limousine Commission’s open dataset](https://opendata.cityofnewyork.us/).

[BigQuery](https://cloud.google.com/bigquery/) is a serverless data warehouse. Tables in BigQuery are organized into datasets. In this lab, messages published into Pub/Sub will be aggregated and stored in BigQuery.

To create a new BigQuery dataset:

### Option 1: The command-line tool

1. Open Cloud Shell (Cloud Shell icon) and run the below command to create the taxirides dataset.

```
bq mk taxirides
```
2. Run this command to create the taxirides.realtime table (empty schema that you will stream into later).

```
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime
```

### Option 2: The BigQuery Console UI

> **Note**: Skip these steps if you created the tables using the command line.

1. In the Google Cloud Console, select **Navigation menu > Analytics > BigQuery**:

2. The Welcome to BigQuery in the Cloud Console message box opens. This message box provides a link to the quickstart guide and lists UI updates.

3. Click on the **View actions** icon next to your Project ID and click **Create dataset**.

4. Set the **Dataset ID** as **taxirides**, leave all the other fields the way they are, and click **CREATE DATASET**.

5. If you look at the left-hand resources menu, you should see your newly created dataset.

6. Click on the **View actions** icon next to the **taxirides** dataset and click **Open**.

7. Click **CREATE TABLE**.

8. Name the table **realtime**.

9. For the schema, click **Edit as text** and paste in the below:

```
    ride_id:string,
    point_idx:integer,
    latitude:float,
    longitude:float,
    timestamp:timestamp,
    meter_reading:float,
    meter_increment:float,
    ride_status:string,
    passenger_count:integer
```
10. Under **Partition and cluster settings**, select the **timestamp** option for the Partitioning field.

11. Click the **CREATE TABLE** button.

## Task 2. Create a Cloud Storage bucket

[Cloud Storage](https://cloud.google.com/storage/) allows world-wide storage and retrieval of any amount of data at any time. You can use Cloud Storage for a range of scenarios including serving website content, storing data for archival and disaster recovery, or distributing large data objects to users via direct download. In this lab, you use Cloud Storage to provide working space for your Dataflow pipeline.

1. In the Cloud Console, go to **Navigation menu > Cloud Storage**.

2. Click **CREATE BUCKET**.

3. For **Name**, paste in your **GCP Project ID** and then click **Continue**.

4. For **Location type**, click **Multi-region** if it is not already selected.

5. Click **CREATE**.

## Task 3. Set up a Dataflow Pipeline

[Dataflow](https://cloud.google.com/dataflow/) is a serverless way to carry out data analysis. In this lab, you set up a streaming data pipeline to read sensor data from Pub/Sub, compute the maximum temperature within a time window, and write this out to BigQuery.

Restart the connection to the Dataflow API.

1. In the Cloud Console, enter **Dataflow API** in the top search bar.

2. Click on the result for **Dataflow API**.

3. Click **Manage**.

4. Click **Disable API**.

5. If asked to confirm, click **Disable**.

6. Click **Enable**.

To create a new streaming pipeline:

1. In the Cloud Console, go to **Navigation menu > Dataflow**.

2. In the top menu bar, click **CREATE JOB FROM TEMPLATE**.

3. Enter **streaming-taxi-pipeline** as the Job name for your Dataflow job.

4. Under **Dataflow template**, select the **Pub/Sub Topic to BigQuery** template.

5. Under **Input Pub/Sub topic**, enter ```projects/pubsub-public-data/topics/taxirides-realtime```

6. Under **BigQuery output table**, enter ```<myprojectid>:taxirides.realtime```

> **Note**: There is a colon : between the project and dataset name and a dot . between the dataset and table name.

7. Under **Temporary location**, enter ```gs://<mybucket>/tmp/```.

8. Click **Show Optional Parameters** and input the following values as listed below:

- **Max workers**: 2

- **Number of workers**: 2

9. Click the **RUN JOB** button.

A new streaming job has started! You can now see a visual representation of the data pipeline.

> **Note**: If the dataflow job fails for the first time then re-create a new job template with new job name and run the job.

## Task 4. Analyze the taxi data using BigQuery

To analyze the data as it is streaming:

1. In the Cloud Console, select **Navigation menu > BigQuery**.

2. Enter the following query in the query **EDITOR** and click **RUN**:

```
SELECT * FROM taxirides.realtime LIMIT 10
```
3. If no records are returned, wait another minute and re-run the above query (Dataflow takes 3-5 minutes to setup the stream). You will receive a similar output:

![TASK_4_3](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20II%20-%20Creating%20a%20streaming%20data%20pipeline%20for%20a%20Real-Time%20dashboard%20with%20Dataflow/Images/task_4_3.png?raw=true)

## Task 5. Perform aggregations on the stream for reporting

1. Copy and paste the below query and click **RUN**.

```
WITH streaming_data AS (
SELECT
  timestamp,
  TIMESTAMP_TRUNC(timestamp, HOUR, 'UTC') AS hour,
  TIMESTAMP_TRUNC(timestamp, MINUTE, 'UTC') AS minute,
  TIMESTAMP_TRUNC(timestamp, SECOND, 'UTC') AS second,
  ride_id,
  latitude,
  longitude,
  meter_reading,
  ride_status,
  passenger_count
FROM
  taxirides.realtime
WHERE ride_status = 'dropoff'
ORDER BY timestamp DESC
LIMIT 1000
)
# calculate aggregations on stream for reporting:
SELECT
 ROW_NUMBER() OVER() AS dashboard_sort,
 minute,
 COUNT(DISTINCT ride_id) AS total_rides,
 SUM(meter_reading) AS total_revenue,
 SUM(passenger_count) AS total_passengers
FROM streaming_data
GROUP BY minute, timestamp
```

> **Note**: Ensure dataflow is registering data in BigQuery before proceeding to the next task.

The result shows key metrics by the minute for every taxi drop-off.

![TASK_5_1](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20II%20-%20Creating%20a%20streaming%20data%20pipeline%20for%20a%20Real-Time%20dashboard%20with%20Dataflow/Images/task_5_1.png?raw=true)

## Task 6. Stop the Dataflow job

1. Navigate back to **Dataflow**.

2. Click the **streaming-taxi-pipeline** or the new job name.

3. Click **STOP** and select **Cancel > STOP JOB**.

This will free up resources for your project.

## Task 7. Create a real-time dashboard

1. Open this [Google Data Studio link](https://datastudio.google.com/overview) in a new incognito browser tab.

2. On the **Reports** page, in the **Start with a Template** section, click the **[+] Blank Report** template.

3. If prompted with the **Welcome to Google Studio** window, click **Get started**.

4. Check the checkbox to acknowledge the Google Data Studio Additional Terms, and click **Continue**.

5. Select **No** to all the questions, then click **Continue**.

6. Switch back to the **BigQuery** Console.

7. Click **EXPLORE DATA > Explore with Data Studio** in BigQuery page.

8. Click **GET STARTED**, then click **AUTHORIZE**.

9. Specify the below settings:

  - **Chart type**: ```Combo chart```
  - **Date range Dimension**: ```dashboard_sort```
  - **Dimension**: ```dashboard_sort```
  - **Drill Down**: ```dashboard_sort``` (Make sure that Drill down option is turned ON)
  - **Metric**: ```SUM() total_rides```, ```SUM() total_passengers```, ```SUM() total_revenue```
  - **Sort**: ```dashboard_sort```, ```Ascending``` (latest rides first)

Your chart should look similar to this:

![TASK_7_9](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20II%20-%20Creating%20a%20streaming%20data%20pipeline%20for%20a%20Real-Time%20dashboard%20with%20Dataflow/Images/task_7_9.png?raw=true)

> **Note**: Visualizing data at a minute-level granularity is currently not supported in Data Studio as a timestamp. This is why we created our own dashboard_sort dimension.

10. When you're happy with your dashboard, click **Save** to save this data source.

11. Whenever anyone visits your dashboard, it will be up-to-date with the latest transactions. You can try it yourself by clicking on the Refresh button near the Save button.

## Task 8. Create a time series dashboard

1. Click this [Google Data Studio link](https://datastudio.google.com/overview) to open Data Studio in a new browser tab.

2. On the **Reports** page, in the **Start with a Template** section, click the **[+] Blank Report** template.

3. A new, empty report opens with **Add data to report**.

4. From the list of **Google Connectors**, select the **BigQuery** tile.

5. Under **CUSTOM QUERY**, click **qwiklabs-gcp-xxxxxxx > Enter Custom Query**, add the following query.

```
SELECT
  *
FROM
  taxirides.realtime
WHERE
  ride_status='dropoff'
```
6. Click **Add > ADD TO REPORT**.

### Create a time series chart

1. In the **Data** panel, scroll down to the bottom right and click **ADD A FIELD**. Click **All Fields** on the left corner.

2. Change the field **timestamp** type to **Date & Time > Date Hour Minute (YYYYMMDDhhmm)**.

3. Click **Continue** and then click **Done**.

4. Click **Add a chart**.

5. Choose **Time series chart**.

6. Position the chart in the bottom left corner - in the blank space.

7. In the **Data** panel on the right, change the following:

- **Dimension**: ```timestamp```
- **Metric**: ```meter_reading(SUM)```

Your time series chart should look similar to this:

![TASK_8_7](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20II%20-%20Creating%20a%20streaming%20data%20pipeline%20for%20a%20Real-Time%20dashboard%20with%20Dataflow/Images/task_8_7.png?raw=true)

> **Note**: if Dimension is timestamp(Date), then click on calendar icon next to timestamp(Date), and select type to **Date & Time > Date Hour Minute**.

## Congratulations!

In this lab, you used Pub/Sub to collect streaming data messages from taxis and feed it through your Dataflow pipeline into BigQuery.

---

# Finished Lab