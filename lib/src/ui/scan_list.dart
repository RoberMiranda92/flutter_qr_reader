
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/src/resources/models/scan_model.dart';

class ScanList extends StatelessWidget {

  final List<ScanModel> list;
  final Function(ScanModel scan) onClick;
  final Function(ScanModel scan) onDismissed;

  ScanList(this.list, this.onClick, this.onDismissed);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var scan = list[index];
                    return Column(
                      children: <Widget>[
                        Dismissible(
                          key: UniqueKey(),
                          child: ListTile(
                            onTap: () {
                              onClick(scan);
                              //_manageScanClick(scan, context);
                            },
                            leading: Icon(
                              scan.type == ScanType.GEO
                                  ? Icons.map
                                  : Icons.cloud_queue,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(scan.value),
                            subtitle: Text(scan.id.toString()),
                            trailing: Icon(Icons.arrow_right),
                          ),
                          onDismissed: (direction) {
                            onDismissed(scan);
                            //ScanBloc.getInstance().delete(scan);
                          },
                          background: Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.red,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Delete",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: list.length,
                ),
    );
  }
}