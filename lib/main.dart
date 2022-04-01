// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables, non_constant_identifier_names


import 'package:flutter/material.dart';
import 'contactlist.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';


void main() => runApp(MaterialApp(
      home: contact(),
    ));

class contact extends StatefulWidget {
  const contact({Key? key}) : super(key: key);

  @override
  State<contact> createState() => _contactState();
}

class _contactState extends State<contact> {
  bool value = false;

  Widget buildSwitch() => Switch.adaptive(  //Build toggle switch
        value: value,
        onChanged: (value) => setState(() => this.value = value),
        activeColor: Colors.red,
        splashRadius: 20,
      );

  Future<List<contactlist>> ReadContactList() async { //Read json file
    final response = await rootBundle.loadString('assets/contact.json');
    final list = json.decode(response) as List<dynamic>;

    return list.map((e) => contactlist.fromJson(e)).toList();
  }

  String togglecheckin(String d) {  //Change timeago or DateTime
    if (value == true) {
      return d;
    } else {
      return timeAgo(d);
    }
  }

  String timeAgo(String d) {    //Timeago algorithm
    DateTime x = DateTime.parse(d);
    Duration diff = DateTime.now().difference(x);

    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  Widget EndofList() {    //End of list function
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 20),
      width: 1000,
      child: Text(
        "You have reached end of the list",
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
      color: Colors.blue,
    );
  }

  Future<void> Addcontact() async { //Append 5 random into list
    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Contact List",
          ),
          actions: [buildSwitch()],
        ),
        body: RefreshIndicator(
            onRefresh: Addcontact,
            child: FutureBuilder(
                future: ReadContactList(),
                builder: (context, data) {
                  if (data.hasError) {
                    return Text("${data.error}");
                  } else if (data.hasData) {
                    var items = data.data as List<contactlist>;

                    items.sort(
                        (b, a) => a.checkin!.compareTo(b.checkin as DateTime));
                    return ListView.builder(
                      // ignore: unnecessary_null_comparison
                      itemCount: items == null ? 0 : items.length,

                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ExpansionTile(
                              tilePadding: EdgeInsets.all(10),
                              title: (Text("${items[index].user}")),
                              subtitle: Text(
                                  togglecheckin("${items[index].checkin}")),
                              textColor: Colors.black,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: Text(
                                        "${items[index].phone}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    )),
                                    IconButton(
                                      onPressed: () async{
                                        await Share.share('${items[index].user} -  ${items[index].phone}');
                                      },
                                      icon: Icon(Icons.share),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            index == items.length - 1 ? EndofList() : Center()
                          ],
                        );
                      },

                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }
}
