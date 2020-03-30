# Camshare

## About
Camshare is a mobile application developed for iOS devices. The purpose of the app is to give users a platform to make groups with their friends to share photos. Camshare allows a user to add photos to an album by directly taking pictures with the built in camera.

## Users and Accounts
Users will be able to create new accounts using google firebase as the account provider OR sign up/sign in with their facebook or gmail accounts.

Each user will have the ability to create groups, ivite their friends or join another group by reading a QR code or accepting an ivitation link shared via Whatsapp email or any other messaging platform.

## Albums 

### Overview
Albums can be created and shared. Albums can be viewed by tapping on the desired album, app will navigate to a new collection displaying all the images inside the album.
A thumnail, representing the album, will be a random image inside the Album.

### Creating Albums
- On creating the album, the user can give the album a name. 
- A 25 character unique ID will be generated for the album.
- The album is added to the user's existing albums.

### Sharing Albums
Sharing albums allow users to contribute to the album's images.
Sharing albums can be done in two different ways:

**Scan QR Code**
- Device A tap **"share"** then tap **Generate QR COode**.
- Device B tap **" + "** the tap **Scan QR Code**.
- Hover **camera** over generated QR Code on device B.
- Album is now added.

**Copy and Paste**
- Device A tap **"share"** then tap **Copy Album ID**.
- This Album ID can be shared over media platforms like Whatsapp, Facebook or Email.
- Device B tap **" + "** the tap **Existing Album**, paste the Album ID and tap **Add**.
- Album is now added.

### Deleting Albums
User can delete an album at any point. 
- Tap **"Edit"**, select an Album and tap **"Delete"**.

## Single Album
### Overview
Users can take pictures from here that will be added to its album's images. 

### Take Pictures
User can take pictures with built in camera.
- Tap **"camera icon"**, take the picture.
- When **"Use Photo"** is tapped the photo will be saved to the database and added to the collection view.
- Retake the image by tapping **"Retake"**.
 
**Expected Features:**
-  Camera that allows realtime editing.
-  Allowing Camshare to create video presentations of an album with music backgrounds within the app.
-  Apple Music API to accomodate video presentations

**Background Operations:**
-  The github repository is added to Bitrise, this will allow the app to be build and tested by the bitrise build server.
-  A Workflow is setup in bitrise with a slackbot to send a message to a slack account of all changes that are made in the repository.
-  The slackbot will also send an appropriate message if the build was succesful or failed.
-  The github repository is also added to Codacy, which will Evalute the quality of the code and make you aware of certain issues in the code.

### Extra
###### Badges

[![Build Status](https://app.bitrise.io/app/f5ef16cbcd43fa3b/status.svg?token=l9zpYE6QPNcmWmfvOyNAAg)](https://app.bitrise.io/app/f5ef16cbcd43fa3b)

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/53d2304155fb4b9e87b254ce205bcade)](https://www.codacy.com/manual/JancoDVTDev/camshare?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=JancoDVTDev/camshare&amp;utm_campaign=Badge_Grade)
