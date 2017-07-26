module Data exposing (videoData, VideoData, TextTime)

import Json.Decode exposing (Decoder)
import Debug


videoData : VideoData
videoData =
    case Json.Decode.decodeString videoDataDecoder dataString of
        Ok data ->
            data

        Err error ->
            Debug.crash "Invalid JSON, make sure the the structure is correct."


type alias VideoData =
    { videoId : String
    , lines : List TextTime
    }


type alias TextTime =
    { text : String
    , time : Float
    }


videoDataDecoder : Decoder VideoData
videoDataDecoder =
    Json.Decode.map2 VideoData
        (Json.Decode.field "videoId" Json.Decode.string)
        (Json.Decode.field "lines" (Json.Decode.list textTimeDecoder))


textTimeDecoder : Decoder TextTime
textTimeDecoder =
    Json.Decode.map2 TextTime
        (Json.Decode.field "text" Json.Decode.string)
        (Json.Decode.field "time" Json.Decode.float)


dataString : String
dataString =
    """{
  "videoId": "SeBdb9V5ag4",
  "lines": [
    {
      "text": "You know, Chandler, you're doing so well",
      "time": 3.6
    },
    {
      "text": "with this whole \\"getting married never gonna sleep with anyone",
      "time": 5.3
    },
    {
      "text": "for the rest of life\\" thing.",
      "time": 7.5
    },
    {
      "text": "I'm telling ya, this is great.",
      "time": 8.6
    },
    {
      "text": "Hey.",
      "time": 13.3
    },
    {
      "text": "Hi.",
      "time": 13.3
    },
    {
      "text": "Who wants French toast?",
      "time": 14.4
    },
    {
      "text": "Oh, I'll have some.",
      "time": 15.9
    },
    {
      "text": "Me, too.",
      "time": 15.9
    },
    {
      "text": "Eggs and milk in the fridge. Thanks.",
      "time": 17.9
    },
    {
      "text": "Ow!",
      "time": 20.7
    },
    {
      "text": "Oh, what's the matter, honey?",
      "time": 22.1
    },
    {
      "text": "My hand feels weird.",
      "time": 23.7
    },
    {
      "text": "I guess it's because I'm engaged!",
      "time": 24.7
    },
    {
      "text": "How long before",
      "time": 26.9
    },
    {
      "text": "that starts getting annoying?",
      "time": 28.6
    },
    {
      "text": "Starts?",
      "time": 30.2
    },
    {
      "text": "So, let's actually get started on the wedding plans.",
      "time": 32.7
    },
    {
      "text": "Okay.",
      "time": 34.9
    },
    {
      "text": "Already?",
      "time": 36
    },
    {
      "text": "Yeah, we got a lot to do.",
      "time": 37
    },
    {
      "text": "We got to think about flowers, the caterers, the music.",
      "time": 38.5
    },
    {
      "text": "Oh, I got thoughts on the music.",
      "time": 40.7
    },
    {
      "text": "Oh, Chandler, too many cooks.",
      "time": 41.8
    },
    {
      "text": "Take it from me. As the groom,",
      "time": 45.3
    },
    {
      "text": "all you have to do is show up and try to say the right name.",
      "time": 46.9
    },
    {
      "text": "Okay.",
      "time": 52.2
    },
    {
      "text": "What in God's name is that?",
      "time": 53.5
    },
    {
      "text": "Oh, my God. The wedding book?",
      "time": 55.5
    },
    {
      "text": "I haven't seen that since the fourth grade.",
      "time": 57.6
    },
    {
      "text": "This baby has got everything.",
      "time": 60.2
    },
    {
      "text": "Take, you know, locations, for instance:",
      "time": 62.8
    },
    {
      "text": "first organized alphabetically, then geographically",
      "time": 65.4
    },
    {
      "text": "then by square footage.",
      "time": 69
    },
    {
      "text": "That is so smart.",
      "time": 73.6
    },
    {
      "text": "Break it off.",
      "time": 74.8
    },
    {
      "text": "Break it off now.",
      "time": 76.8
    },
    {
      "text": "Oh, my... Look, here's the invitation you used",
      "time": 78.8
    },
    {
      "text": "to your wedding to John Linch in the fifth grade.",
      "time": 81.3
    },
    {
      "text": "Remember I got sick, and Ross had to fill in as a bridesmaid.",
      "time": 84
    },
    {
      "text": "I was a bridesboy!",
      "time": 89.4
    },
    {
      "text": "I don't smell French toast, bridesboy.",
      "time": 93
    }
  ]
}"""
