import 'package:Youthpreneur_Hub/datamodel/workshop_data_model.dart';
import 'package:Youthpreneur_Hub/datamodel/workshop_participant.dart';
import 'package:flutter/material.dart';

class WorkShopPage extends StatefulWidget {
  const WorkShopPage({super.key});

  @override
  State<WorkShopPage> createState() => _WorkShopPageState();
}

class _WorkShopPageState extends State<WorkShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workshops',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
        //backgroundColor: Colors.teal[100],
        elevation: 5,
      ),
      body: StreamBuilder<List<WorkshopDataModel>>(
        stream: WorkshopDataModel.fetchWorkshopStream(),
        builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        final workshopParticipants = snapshot.data!;
      
        return ListView.builder(
          itemCount: workshopParticipants.length,
          itemBuilder: (context, index) {
            WorkshopDataModel participant = workshopParticipants[index];
      
            return GestureDetector(
              onTap: () {
                showDialog(
  context: context,
  builder: (BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final workshopNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneNoController = TextEditingController();
    final ageController = TextEditingController();
    final cityController = TextEditingController();

    return AlertDialog(
      title: Text('Apply for Workshop'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: workshopNameController,
              decoration: InputDecoration(labelText: 'Workshop Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter workshop name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: phoneNoController,
              decoration: InputDecoration(labelText: 'Phone No'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter phone no';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter age';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter city';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
                    TextButton(
                      child: Text('Create'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Create a new WorkshopParticipant object
                          WorkshopParticipant workshopParticipant = WorkshopParticipant(
                            name: nameController.text,
                            workshop_name: workshopNameController.text,
                            email: emailController.text,
                            phone_no: int.parse(phoneNoController.text),
                            age: int.parse(ageController.text),
                            city: cityController.text,
                          );

                          // Call the function to create a new workshop participant
                          WorkshopParticipant.createWorkshopParticipant(workshopParticipant);

                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                );
              },
            );
              },
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        participant.workshopName,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description: ${participant.description}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Date: ${participant.date}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Time: ${participant.time}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Duration: ${participant.duration}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Location: ${participant.location}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Max People: ${participant.maxPeople}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Instructor Name: ${participant.instructorName}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Image.network(participant.image),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
        },
      ),
    );
  }
}