import 'package:decimal/bloc/feed/feed_bloc.dart';
import 'package:decimal/config/theme.dart';
import 'package:decimal/models/publication_items_model.dart';
import 'package:decimal/models/publication_model.dart';
import 'package:decimal/models/user_model.dart';
import 'package:decimal/screens/home/widgets/reactions.dart';
import 'package:decimal/service/feed_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  late List<PublicationModel> publications;
  late List<PublicationItemModel> publicationItems;
  late List<CustomUser> users;

  @override
  initState() {
    super.initState();
    BlocProvider.of<FeedBloc>(context).add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state is FetchPostsSuccess) {
          setState(() {
            publications = state.publications;
            publicationItems = state.publicationItem;
            users = state.users;
          });
        }
      },
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 64,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          color: AppColors.primaryBackground,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Column(
                children: [
                  if (state is FetchPostsSuccess)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final CustomUser user = users[index];
                        final PublicationItemModel publicationItem = publicationItems[index];
                        final PublicationModel publication = publications[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(6.0),
                                              child: Image.network(
                                                user.profile_picture ?? 'https://hxlaujiaybgubdzzkoxu.supabase.co/storage/v1/object/public/Assets/image/amanda_wilson/amanda1.png',
                                                width: 48.0,
                                                height: 48.0,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(user.name ?? '[user_name]', style: Theme.of(context).primaryTextTheme.bodyMedium),
                                              Text(context.read<FeedService>().getDuration(publication.date_of_publication)?.toString() ?? '[x_time_ago]', style: Theme.of(context).primaryTextTheme.labelMedium),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Icon(Icons.more_vert),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: AppColors.primaryBackground,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(publicationItem.content ?? '[publication_content]', style: Theme.of(context).primaryTextTheme.bodyMedium),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Reactions(container: false, publication_id: publication.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    SizedBox(
                      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - kBottomNavigationBarHeight - 48.0,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}