import 'package:flutter/material.dart';
import 'package:google_map/section8/models/autocomplet/autocomplet_model.dart';
import 'package:google_map/section8/models/place_detail_model/place_detail_model.dart';
import 'package:google_map/section8/utils/places_api_service.dart';

class ListAutocomplete extends StatelessWidget {
  const ListAutocomplete({
    super.key,
    required this.data,
    required this.onTap,
  });
  final List<AutocompleteModel> data;
  final Function(PlaceDetailModel) onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: ColoredBox(
        color: Colors.white,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () async {
              try {
                PlaceDetailModel detailData =
                    await PlacesApiService().getPlaceDetailApi(
                  placeId: data[index].placeId,
                );
                onTap(detailData);
              } on PlaceDetailException catch (_) {
              } catch (_) {}
            },
            trailing: const Icon(Icons.arrow_outward),
            leading: const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFD4D0D0),
                child: Icon(
                  Icons.location_on_outlined,
                )),
            dense: true,
            title: Text(
              data[index].description,
            ),
          ),
          separatorBuilder: (context, index) => const Divider(
            height: 0,
          ),
        ),
      ),
    );
  }
}
