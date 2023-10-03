import 'package:example_project/modules/home/cubit/home_cubit.dart';
import 'package:example_project/modules/home/cubit/home_state.dart';
import 'package:example_project/modules/home/model/user.dart';
import 'package:example_project/modules/home/repository/home_repository.dart';
import 'package:example_project/modules/network/services.dart';
import 'package:example_project/modules/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../utils/style.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({Key? key}) : super(key: key);

  @override
  _HomeUiState createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 1);
  static const _pageSize = 6;
  HomeCubit? cubit;
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await cubit?.fetch(pages: pageKey) ?? [];
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(
              HomeRepository(DioService()),
              _pageSize,
            ),
          ),
        ],
        child: BlocConsumer<HomeCubit, HomeState>(
          builder: (context, state) {
            cubit = BlocProvider.of<HomeCubit>(context);
            // if (state is HomeLoading) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else {

            // }
            return PagedListView<int, User>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<User>(
                animateTransitions: true,
                // [transitionDuration] has a default value of 250 milliseconds.
                transitionDuration: const Duration(milliseconds: 500),
                itemBuilder: (context, item, index) {
                  return cardWidget(item);
                },
              ),
            );
          },
          listener: (context, state) {
            if (state is HomeError) {
              showLongSnackBar(context, state.message);
            }
          },
        ),
      ),
    );
  }

  cardWidget(User item) {
    return Card(
      // Define the shape of the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      // Define how the card's content should be clipped
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // Define the child widget of the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Add padding around the row widget
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Add an image widget to display an image
                Image.network(
                  item.avatar ?? '',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                // Add some spacing between the image and the text
                Container(width: 20),
                // Add an expanded widget to take up the remaining horizontal space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add some spacing between the top of the card and the title
                      Container(height: 5),
                      // Add a title widget
                      Text(
                        "${item.firstName} ${item.lastName}",
                        style: MyTextSample.title(context)!.copyWith(
                          color: MyColorsSample.grey_80,
                        ),
                      ),
                      // Add some spacing between the title and the subtitle
                      Container(height: 5),
                      // Add a subtitle widget
                      Text(
                        item.email ?? "Sub title",
                        style: MyTextSample.body1(context)!.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                      // Add some spacing between the subtitle and the text
                      Container(height: 10),
                      // Add a text widget to display some text
                      Text(
                        MyStringsSample.card_text,
                        maxLines: 2,
                        style: MyTextSample.subhead(context)!.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
