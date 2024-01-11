
import 'package:flutter/material.dart';

import '../Extra/pickupprediction.dart';
import '../Extra/place.dart';

import '../Extra/request.dart';




class www extends StatefulWidget
{

  @override
  _wwwState createState() => _wwwState();
}




class _wwwState extends State<www>
{
  List<PredictedPlaces> placesPredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async
  {
    if(inputText.length > 1) //2 or more than 2 input characters
        {
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=AIzaSyBzAohdLUAqnI1K-KMunJVWXIQ0jcow8Ok&components=country:US";

      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch == "Error Occurred, Failed. No Response.")
      {
        return;
      }

      if(responseAutoCompleteSearch["status"] == "OK")
      {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Color(0xFF9f0202),
      body: Column(
        children: [
          //search place ui
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft, // Start from the center-left
                  end: Alignment.topCenter, // End at the center-right
                  colors: [
                    Color(0xFF9f0202),
                    Colors.black,
                  ], // Define your gradient colors
                  // Adjust stops to position the second color in the center
                ),
              ),
              height: 160,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [

                    const SizedBox(height: 55.0),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: TextField(
                                onChanged: (valueTyped)
                                {
                                  findPlaceAutoCompleteSearch(valueTyped);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFF9f0202),
                                  ),
                                  hintStyle: TextStyle(color: Color(0xFF9f0202)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF9f0202), width: 6),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF9f0202), width: 6),
                                  ),
                                  hintText: 'Search Your Pickup Location...',
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          //display place predictions result
          (placesPredictedList.length > 0)
              ? Expanded(
            child: ListView.separated(
              itemCount: placesPredictedList.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index)
              {
                return eee(
                  predictedPlaces: placesPredictedList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index)
              {
                return const Divider(
                  height: 1,
                  color: Colors.white,
                  thickness: 1,
                );
              },
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}