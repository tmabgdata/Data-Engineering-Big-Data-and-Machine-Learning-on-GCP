# Vertex AI: Predicting Loan Risk with AutoML

## Overview

In this lab, you use Vertex AI to train and serve a machine learning model to predict loan risk with a tabular dataset.

### Objectives

- You learn how to:

- Upload a dataset to Vertex AI.

- Train a machine learning model with AutoML.

- Evaluate the model performance.

- Deploy the model to an endpoint.

- Get predictions.

## Introduction to Vertex AI

This lab uses [Vertex AI](https://cloud.google.com/ai-platform-unified/docs?utm_source=codelabs&utm_medium=et&utm_campaign=CDR_sar_aiml_vertexio_&utm_content=-), the unified AI platform on Google Cloud to train and deploy a ML model. Vertex AI offers two options on one platform to build a ML model: a codeless solution with **AutoML** and a code-based solution with **Custom Training** using Vertex **Workbench**. You use **AutoML** in this lab.

In this lab you build a ML model to determine whether a particular customer will repay a loan.

## Task 1: Prepare the training data

The initial Vertex AI dashboard illustrates the major stages to train and deploy a ML model: prepare the training data, train the model, and get predictions. Later, the dashboard displays your recent activities, such as the recent datasets, models, predictions, endpoints, and notebook instances.

### Create a dataset

1. In the Google Cloud Console, on the **Navigation menu**, click **Vertex AI**.

2. Click **Create dataset**.

3. On the Datasets page, give the dataset a name.

4. For the data type and objective, click **Tabular**, and then select **Regression/classification**.

5. Click **Create**.

### Upload data

Three options to import data in Vertex AI:

- Upload a local file from your computer.

- Select files from Cloud Storage.

- Select data from BigQuery.

For convenience, the dataset is already uploaded to Cloud Storage.

1. For the data source, select **Select CSV files from Cloud Storage**.

2. For **Import file path**, enter

```
spls/cbl455/loan_risk.csv
```
3. Click **Continue**.

### (Optional) Generate statistics

1. To see the descriptive statistics for each column of your dataset, click **Generate statistics**. Generating the statistics might take a few minutes, especially the first time.

2. When the statistics are ready, click each column name to display analytical charts.

## Task 2: Train your model

With a dataset uploaded, you're ready to train a model to predict whether a customer will repay the loan.

- Click **Train new model**.

### Training method

The dataset is called _LoanRisk_.

1. For **Objective**, select **Classification**. Select classification instead of regression because you are predicting a distinct number (whether a customer will repay a loan: 0 for repay, 1 for default/not repay) instead of a continuous number.

2. Click **Continue**.

### Model details

Specify the name of the model and the target column.

1. Give the model a name, such as **LoanRisk**.

2. For **Target column**, select **Default**.

3. (Optional) Explore **Advanced options** to determine how to assign the training vs. testing data and specify the encryption.

4. Click **Continue**.

### Training options

Specify which columns you want to include in the training model. For example, ClientID might be irrelevant to predict loan risk.

1. Click the minus sign on the **ClientID** row to exclude it from the training model.

2. (Optional) Explore **Advanced options** to select different optimization objectives. For more information about optimization objectives for tabular AutoML models, [see](https://cloud.google.com/vertex-ai/docs/training/tabular-opt-obj).

3. Click **Continue**.

### Compute and pricing

1. For **Budget**, which represents the number of node hours for training, enter 1. Training your AutoML model for 1 compute hour is typically a good start for understanding whether there is a relationship between the features and label you've selected. From there, you can modify your features and train for more time to improve model performance.

2. Leave early stopping enabled.

3. Click **Start training**.

## Task 3: Evaluate the model performance

Veretex AI provides many metrics to evaluate the model performance. You focus on three:

- **Precision/Recall curve**

- **Confusion Matrix**

- **Feature Importance**

### The Precision/Recall curve

![TASK_3_1](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20IV%20-%20Predicting%20loan%20risk%20with%20AutoML/images/TASK_3_1.png?raw=true)

The confidence threshold determines how a ML model counts the positive cases. A higher threshold increases the precision, but decreases recall. A lower threshold decreases the precision, but increases recall. You can manually adjust the threshold to observe its impact on precision and recall and find the best tradeoff point between the two to meet your business needs.

### The confusion matrix

A [confusion matrix](https://developers.google.com/machine-learning/glossary#confusion-matrix) tells you the percentage of examples from each class in your test set that your model predicted correctly.

![TASK_3_2](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20IV%20-%20Predicting%20loan%20risk%20with%20AutoML/images/TASK_3_2.png?raw=true)

The confusion matrix shows that your initial model is able to predict 100% of the repay examples and 87% of the default examples in your test set correctly, which is not too bad.

You can improve the precentage by adding more examples (more data), engineering new features, and changing the training method, etc.

### The feature importance

In Vertex AI, feature importance is displayed through a bar chart to illustrate how each feature contributes to a prediction. The longer the bar, or the larger the numerical value associated with a feature, the more important it is.

![TASK_3_3](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20IV%20-%20Predicting%20loan%20risk%20with%20AutoML/images/TASK_3_3.png?raw=true)

These feature importance values could be used to help you improve your model and have more confidence in its predictions. You might decide to remove the least important features next time you train a model or to combine two of the more significant features into a [feature cross](https://developers.google.com/machine-learning/glossary#feature-cross) to see if this improves model performance.

Feature importance is just one example of Vertex AI’s comprehensive machine learning functionality called Explainable AI. **Explainable AI** is a set of tools and frameworks to help understand and interpret predictions made by machine learning models.

## Task 4: Deploy the model

Now that you have a trained model, the next step is to create an endpoint in Vertex. A model resource in Vertex can have multiple endpoints associated with it, and you can split traffic between endpoints.

### Create and define an endpoint

1. On your model page, on the **Deploy and test** tab, click **Deploy to endpoint**.

2. For **Endpoint name**, enter a name for your endpoint, such as **LoanRisk**.

3. Click **Continue**.

### Model settings and monitoring

1. Leave the traffic splitting settings as-is.

2. As the machine type for your model deployment, under **Machine type**, select **n1-standard-8, 8 vCPUs, 30 GiB memory**.

3. Leave the remaining settings as-is.

4. Click **Deploy**.

Your endpoint will take a few minutes to deploy. When it is completed, a **green check mark** will appear next to the name.

Now you're ready to get predictions on your deployed model.

## Task 6: Get predictions

In this section, use the Shared Machine Learning (SML) service to work with an existing trained model.

<table>

<tbody>

<tr>
<th>ENVIRONMENT VARIABLE</th>
<th>VALUE</th>
</tr>

<tr>
<td>AUTH_TOKEN</td>
<td>Use the value from the previous section</td>
</tr>

<tr>
<td>ENDPOINT</td>
<td>###---###</td>
</tr>

<tr>
<td>INPUT_DATA_FILE</td>
<td>INPUT-JSON</td>
</tr>

</tbody>

</table>

To use the trained model, you will need to create some environment variables.

1. Open a Cloud Shell window.

2. Replace ```INSERT_SML_BEARER_TOKEN``` with the bearer token value from the previous section:

``` 
AUTH_TOKEN="INSERT_SML_BEARER_TOKEN"
```
3. Download the lab assets:

```
gsutil cp gs://spls/cbl455/cbl455.tar.gz .
```
4. Extract the lab assets:

```
tar -xvf cbl455.tar.gz
```
5. Create an ENDPOINT environment variable:

```
ENDPOINT="https://sml-api-vertex-kjyo252taq-uc.a.run.app/vertex/predict/tabular_classification"
```
6. Create a ```INPUT_DATA_FILE``` environment variable:

> After the lab assets are extracted, take a moment to review the contents. The INPUT-JSON file is used to provide Vertex AI with the model data required.
Alter this file to generate custom predictions. The smlproxy application is used to communicate with the backend.

The file ```INPUT-JSON``` is composed of the following values:

<table>

<tbody>

<tr>
<th>age</th>
<th>ClientID</th>
<th>income</th>
<th>loan</th>
</tr>

<tr>
<td>40.77</td>
<td>997</td>
<td>44964.01</td>
<td>3944.22</td>
</tr>

</tbody>

</table>

Test the SML Service by passing the parameters specified in the environment variables:

1. Perform a request to the SML service:

```
./smlproxy tabular \
  -a $AUTH_TOKEN \
  -e $ENDPOINT \
  -d $INPUT_DATA_FILE
```
This query should result in a response similar to this:

```
SML Tabular HTTP Response:
2022/01/10 15:04:45 {"model_class":"0","model_score":0.9999981}
```
Alter the ```INPUT-JSON``` file to test a new scenario:

<table>

<tbody>

<tr>
<th>age</th>
<th>ClientID</th>
<th>income</th>
<th>loan</th>
</tr>

<tr>
<td>30.00</td>
<td>998</td>
<td>50000.00</td>
<td>20000.00</td>
</tr>

</tbody>

</table>

Test the SML Service by passing the parameters specified in the environment variables:

1. Edit the file ```INPUT-JSON``` and replace the original values.

2. Perform a request to the SML service:

```
./smlproxy tabular \
  -a $AUTH_TOKEN \
  -e $ENDPOINT \
  -d $INPUT_DATA_FILE
```
In this case, assuming that the person's income is 50,000, age 30, and loan 20,000, the model predicts that this person will repay the loan.

This query should result in a response similar to this::

```
SML Tabular HTTP Response:
2022/01/10 15:04:45 {"model_class":"0","model_score":0.9999981}
```
If you use the Google Cloud Console, the following image illustrates how the same action could be performed:

![TASK_5](https://github.com/tmabgdata/Data-Engineering-Big-Data-and-Machine-Learning-on-GCP/blob/master/Google%20Cloud%20Big%20Data%20and%20Machine%20Learning%20Fundamentals/Lab%20IV%20-%20Predicting%20loan%20risk%20with%20AutoML/images/TASK_5.png?raw=true)

You can now use Vertex AI to:

- Upload a dataset.

- Train a model with AutoML.

- Evaluate the model performance.

- Deploy the trained AutoML model to an endpoint.

- Get predictions.

🎉 Congratulations! 🎉

To learn more about different parts of Vertex AI, see the [Vertex AI documentation](https://cloud.google.com/ai-platform-unified/docs?utm_source=codelabs&utm_medium=et&utm_campaign=CDR_sar_aiml_vertexio_&utm_content=-).

---

# Finished Lab
