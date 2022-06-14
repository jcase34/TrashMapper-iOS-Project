#  Firebase Information


https://stackoverflow.com/questions/58469347/realtime-database-vs-firestore
https://www.airpair.com/firebase/posts/structuring-your-firebase-data
https://stackoverflow.com/questions/46765999/difference-between-real-time-database-and-firestore-in-firebase

FireStore vs RealTime Database

Realtime Database:
One giant JSON file
Realtime Updates
Single Region
Security?
Bandwidth/Storage charges
Doing multiple updates on the same user (adding posts) may be easier and/or cheaper???  

FireStore:
Collection of documents
Realtime updates
multiple regions
Sort and filter data
Advanced writing/reading data

How do I want data structured on the back end? What features do I want?
Easily delete locations (thiking of deleting locations after 2wks to 1month out)
Sort data based on location

A flat (denormalized) structure:

"Users" : {
    "user1" : {
        "Username" : "John"
        "Password" : "Applesseed"
        "TaggedLocations" : {
            "Location1" : {
                "photoURL" : photoURL, a string?
                "Longitude" : 134.54
                "Latitude" : 85.124
                "LocationDescription" : Trash near street
                "Date" : 24Jan 2022
            }
            "Location2" : {
                "photoURL" : photoURL, a string?
                "Longitude" : 235.4
                "Latitude" : 08.5
                "LocationDescription" : Trash in a park
                "Date" : 24Jan 2022

            }
        }
    "User2" : {...
    "User3" : {...}
}


All locations will be unique. Users can post as many locations as they want. Set a limit? 
Pull only Locations data for fetching
Is there another way to break out the locations? Care about sorting by location relative to current user? Or just show all locations?


Another options for storing locations:

"Users" : {
    "user1" : {
        "Username" : "John"
        "Password" : "Appleseed"
        "TaggedLocations" : {
            "Location1" : True
            "Location2" : True
            "Loation3" : false
        }
    }
    
    "user2" : {
        "Username" : "Sara"
        "Password" : "Appleseed"
        "TaggedLocations" : {
            "Location1" : false
            "Location2" : false
            "Loation3" : true
        }
}

"Locations" : {
        Location1 : {
        "photoURL" : "some string"
        "Longitude" : 133.32
        "Latitude" : 41.24
        "Date" : 02Jan2022
        "LocationDescription" : Trash near playground
    }  
    
    Location2 : {
        "photoURL" : "some string"
        "Longitude" : 851.123
        "Latitude" : 06.348
        "Date" : 02Jan2022
        "LocationDescription" : trash in alley
    } 
    
    Location3 : {
        "photoURL" : "some string"
        "Longitude" : 168.1
        "Latitude" : 87.3
        "Date" : 02Jan2022
        "LocationDescription" : Trash at beach
    } 
     
}
