# Camshare

## About
Camshare is a mobile application developed for iOS devices. The purpose of the app is to give users a platform to make groups with their friends to share photos. Camshare is equipped with a camera that allows a user to add photos to a group by directly taking pictures with the built in camera.

**Expected Features:**
- Camera that allows realtime editing.
- Viewing Albums as a collection.
- Allowing Camshare to create video presentations of an album with music backgrounds within the app.
- Spotifi API to accomodate video presentations

**Background Operations:**
- The github repository is added to Bitrise, this will allow the app to be build and tested by the bitrise build server.
- A Workflow is setup in bitrise with a slackbot to send a message to a slack account of all changes that are made in the repository.
- The slackbot will also send an appropriate message if the build was succesful or failed.
- The github repository is also added to Codacy, which will Evalute the quality of the code and make you aware of certain issues in the code.

## Extra
###### Badges

[![Build Status](https://app.bitrise.io/app/f5ef16cbcd43fa3b/status.svg?token=l9zpYE6QPNcmWmfvOyNAAg)](https://app.bitrise.io/app/f5ef16cbcd43fa3b)

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/53d2304155fb4b9e87b254ce205bcade)](https://www.codacy.com/manual/JancoDVTDev/camshare?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=JancoDVTDev/camshare&amp;utm_campaign=Badge_Grade)
