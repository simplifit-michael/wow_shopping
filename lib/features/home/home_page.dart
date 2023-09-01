import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/features/home/widgets/promo_carousel.dart';
import 'package:wow_shopping/features/main/cubit/product_cubit.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/category_nav_list.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/content_heading.dart';
import 'package:wow_shopping/widgets/product_card.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onCategoryItemPressed(CategoryItem value) {
    // FIXME: implement filter or deep link?
  }

  void _onPromoPressed(PromoModel promo) {
    // FIXME: demo of gotoSection
    if (promo.asset == Assets.promo1) {
      MainScreen.of(context).gotoSection(NavItem.wishlist);
    } else if (promo.asset == Assets.promo2) {
      MainScreen.of(context).gotoSection(NavItem.cart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          children: [
            TopNavBar(
              title: Padding(
                padding: verticalPadding8,
                child: SvgPicture.asset(Assets.logo),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // FIXME: implement filter
                  },
                  icon: const AppIcon(iconAsset: Assets.iconFilter),
                ),
                IconButton(
                  onPressed: () {
                    // FIXME: implement search
                  },
                  icon: const AppIcon(iconAsset: Assets.iconSearch),
                ),
              ],
              bottom: CategoryNavList(
                onCategoryItemPressed: _onCategoryItemPressed,
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: PromoCarousel(
                      promos: const [
                        PromoModel(asset: Assets.promo1),
                        PromoModel(asset: Assets.promo2),
                        PromoModel(asset: Assets.promo1),
                        PromoModel(asset: Assets.promo2),
                      ],
                      onPromoPressed: _onPromoPressed,
                    ),
                  ),
                  const SliverTopSelling(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class SliverTopSelling extends StatelessWidget {
  const SliverTopSelling({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      return SliverMainAxisGroup(
        slivers: [
          SliverPadding(
            padding: horizontalPadding8,
            sliver: SliverToBoxAdapter(
              child: ContentHeading(
                title: 'Top Selling Items',
                buttonLabel: 'Show All',
                onButtonPressed: () {
                  // FIXME: show all top selling items
                },
              ),
            ),
          ),
          sliverMainAxisVerticalMargin8,
          for (int index = 0;
              index < state.topSelling.length;
              index += 2) ...[
            Builder(
              builder: (BuildContext context) {
                final item1 = state.topSelling[index + 0];
                if (index + 1 < state.topSelling.length) {
                  final item2 = state.topSelling[index + 1];
                  return SliverCrossAxisGroup(
                    slivers: [
                      sliverCrossAxisHorizontalMargin12,
                      SliverCrossAxisExpanded(
                        flex: 2,
                        sliver: SliverProductCard(
                          key: Key('top-selling-${item1.id}'),
                          item: item1,
                        ),
                      ),
                      sliverCrossAxisHorizontalMargin12,
                      SliverCrossAxisExpanded(
                        flex: 2,
                        sliver: SliverProductCard(
                          key: Key('top-selling-${item2.id}'),
                          item: item2,
                        ),
                      ),
                      sliverCrossAxisHorizontalMargin12,
                    ],
                  );
                } else {
                  return SliverCrossAxisGroup(
                    slivers: [
                      sliverCrossAxisHorizontalMargin12,
                      SliverCrossAxisExpanded(
                        flex: 1,
                        sliver: SliverProductCard(
                          key: Key('top-selling-${item1.id}'),
                          item: item1,
                        ),
                      ),
                      sliverCrossAxisHorizontalMargin12,
                      const SliverCrossAxisExpanded(
                        flex: 1,
                        sliver: emptySliver,
                      ),
                      sliverCrossAxisHorizontalMargin12,
                    ],
                  );
                }
              },
            ),
            sliverMainAxisVerticalMargin12,
          ],
          sliverMainAxisVerticalMargin48,
          sliverMainAxisVerticalMargin48,
        ],
      );
    });
  }
}
