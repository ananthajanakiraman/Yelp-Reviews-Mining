# CS598dm---Classification Competition

In this assignment, we will use the MeTA toolkit to participate in a classification competition.
Our dataset comes from a real-word application: predicting whether a
restaurant will pass its health inspection given its text review data!

**Your goal is to experiment and see how far up on [the
leaderboard](http://capstone-leaderboard.westcentralus.cloudapp.azure.com)
you can get!**

## Setup
We'll use [metapy](https://github.com/meta-toolkit/metapy)---Python bindings for MeTA. 
If you have not installed metapy so far, use the following commands to get started.

```bash
# Ensure your pip is up to date
pip install --upgrade pip

# install metapy!
pip install metapy pytoml
```

If you're on an EWS machine
```bash
module load python3
# install metapy on your local directory
pip install metapy pytoml --user
```

## Competition Setup
This is a two-step process. First, we'll make an access token for your user
(this is submitted along with the competition results for authentication),
and then set the needed pipeline variables to submit your results to the
leaderboard.

### Making an Access Token
Go to the upper right hand corner and click the drop-down and go to
"Settings". From there, go to "Access Tokens". Create a new token (it can
be called whatever you'd like, but I used "Competition API"), and give it
the **read_user** scope. Then, click "Create personal access token". There
will be a box at the top of the screen that appears with the access token.
**Make sure to copy this to your clipboard as you won't be able to see it
again!**

### Configuring Pipeline Variables
Now that you have your access token copied to your clipboard, go back to
your fork of the repository. Click on "Settings", and then "Pipelines".
Look for the "**Secret variables**" section. We'll need to add two
variables. The first will be called `GITLAB_API_TOKEN`. Set the value to
the access token you copied before.

Finally, create another variable called `COMPETITION_ALIAS` and set that to
whatever you'd like your entry to be named on the leaderboard.

Once both of these variables are set, you should be ready to go! Each push
to this repository should start a build job that runs your code and submits
the results to the leaderboard to be judged.

## Training a classifier
This repository contains what you need to begin participating in
the classification competition. You will want to change the code in the
`make_classifier()` function in the file `classify.py` to use a different
classifier. You might also want to try changing your feature
representation by modifying the `[[analyzers]]` table array in
`config.toml`. You can also modify the `transform_dataset()` function to
modify the existing feature values, or to add additional features to the
dataset provided. See the comments of that function for more information.

If you want to use an external tool, you will need to change the script in
`.gitlab-ci.yml` to install and run your external tool, and then update the
`get_results()` function in `competition.py` to read the output of that
tool for submitting to the leaderboard.

Thus, the only files that you will have to update are `classify.py` and `config.toml` (or `.gitlab-ci.yml` and `competition.py` if using a non-Python tool).
Please do not edit the rest of the files in the repository, as you might experience issues with submitting.

A nice tutorial about text classification with metapy, as well as some config.toml files
can be found [here](https://github.com/meta-toolkit/metapy/blob/master/tutorials/4-classification.ipynb)

## Submitting Results
With that all configured, you should be done! Now whenever you push code to
this repository (note that you need to commit locally first, and then push
to the repository here because we're using `git`), it should automatically
update the leaderboard. You can see the output of the job by looking in the
"Pipelines" section on your repository.

You can play with things locally by using the "ceeaus" dataset found in the [classification tutorial](https://github.com/meta-toolkit/metapy/blob/master/tutorials/4-classification.ipynb):

```bash 
wget -N https://meta-toolkit.org/data/2016-01-26/ceeaus.tar.gz
tar xvf ceeaus.tar.gz
```
Note that the datasets we are using for the leaderboard are different, so the accuracy running locally with  the "ceeaus" dataset will vary from the leaderboard score.
Just copy the folder into this directory and you should be able to get output with `python classify.py config.toml`.

## [Classificaton Competition Leaderboard](http://capstone-leaderboard.westcentralus.cloudapp.azure.com)
Try to get a top position in the competition leaderboard!

Good luck!
