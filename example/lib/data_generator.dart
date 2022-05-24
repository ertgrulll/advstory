/// Creates test data for the stories.
List<User> generateMockData() {
  const data = [
    {
      "username": "Esther W Roberts",
      "profilePicture":
          "https://www.fakepersongenerator.com/Face/female/female1023053261475.jpg",
      "stories": [
        {
          "url":
              "https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4",
          "mediaType": "video",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1651979822227-31948d6c83bc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
          "mediaType": "image",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1641978909561-015aaa540119?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
          "mediaType": "image",
        },
        {
          "mediaType": "widget",
        },
      ],
    },
    {
      "username": "Virgil T Vogel",
      "profilePicture":
          "https://www.fakepersongenerator.com/Face/male/male1085513896637.jpg",
      "stories": [
        {
          "url":
              "https://images.unsplash.com/photo-1652007682665-e06a8ac589dd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
          "mediaType": "image",
        },
        {
          "url":
              "https://assets.mixkit.co/videos/preview/mixkit-man-under-multicolored-lights-1237-large.mp4",
          "mediaType": "video",
        },
        {
          "url":
              "https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4",
          "mediaType": "video",
        },
      ],
    },
    {
      "username": "Paula A Dixon",
      "profilePicture":
          "https://www.fakepersongenerator.com/Face/female/female20131023576348938.jpg",
      "stories": [
        {
          "url":
              "https://assets.mixkit.co/videos/preview/mixkit-two-avenues-with-many-cars-traveling-at-night-34562-large.mp4",
          "mediaType": "video",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1641981601596-39a7403ebf47?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80",
          "mediaType": "image",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1593642634443-44adaa06623a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1325&q=80",
          "mediaType": "image",
        },
      ]
    },
    {
      "username": "Barbara W Yanez",
      "profilePicture":
          "https://www.fakepersongenerator.com/Face/female/female1021769569641.jpg",
      "stories": [
        {
          "url":
              "https://images.unsplash.com/photo-1641982661987-351363e6785e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
          "mediaType": "image",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1641982705401-1f0ed07ff5d0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=699&q=80",
          "mediaType": "image",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1651868722939-61ed67817328?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
          "mediaType": "image",
        },
      ]
    },
    {
      "username": "Johnny N Hayes",
      "profilePicture":
          "https://www.fakepersongenerator.com/Face/male/male20161086415248322.jpg",
      "stories": [
        {
          "url":
              "https://images.unsplash.com/photo-1641984286013-d45a1d1e602d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
          "mediaType": "image",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1641984790242-d8aa477d306c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80",
          "mediaType": "image",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1641948598832-81c0db0ead86?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80",
          "mediaType": "image",
        },
      ]
    },
  ];

  return usersFromMap(data);
}

List<User> usersFromMap(List<Map<String, dynamic>> data) =>
    data.map((e) => User.fromMap(e)).toList();

// Dumb model classes to holding the data
class User {
  final String username;
  final String profilePicture;
  List<Story> stories;

  User(this.username, this.profilePicture, this.stories);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['username'],
      map['profilePicture'],
      map['stories'].map<Story>((story) => Story.fromJson(story)).toList(),
    );
  }
}

class Story {
  final String url;
  final MediaType mediaType;

  Story(this.url, this.mediaType);

  factory Story.fromJson(Map<String, dynamic> map) {
    return Story(
      map['url'] ?? "",
      MediaType.values.firstWhere(
        (element) => element.toString().split(".").last == map['mediaType'],
      ),
    );
  }
}

enum MediaType {
  image,
  video,
  widget,
}
