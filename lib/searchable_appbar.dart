import 'package:flutter/material.dart';

/// Callback signature for when a search query is submitted.
typedef OnSearch = void Function(String query);

/// Callback signature for when the text in the search field changes.
typedef OnChanged = void Function(String query);

/// Callback signature for when the leading icon (e.g., menu or back button) is pressed.
typedef OnLeadingPressed = void Function();

/// A customizable AppBar that can easily switch between a title view and a search input field.
///
/// It implements [PreferredSizeWidget] for use directly in a [Scaffold].
class SearchableAppbar extends StatefulWidget implements PreferredSizeWidget {
  /// The title text to display when the search bar is inactive.
  final String title;

  /// The icon displayed on the left side of the AppBar (e.g., menu or back).
  final IconData leadingIcon;

  /// Callback function when the user submits the search query.
  final OnSearch? onSearch;

  /// Callback function when the text in the search field changes.
  final OnChanged? onChanged;

  /// Callback function when the leading icon is pressed.
  final OnLeadingPressed? onLeadingPressed;

  /// The height of the toolbar. Defaults to [kToolbarHeight].
  final double toolbarHeight;

  /// Alignment for the title widget when not searching.
  final Alignment titleAlignment;

  /// The shape of the AppBar's material. Can be used to create rounded corners.
  final ShapeBorder? bottomShape;

  /// Widget that appears across the bottom of the AppBar.
  final PreferredSizeWidget? bottom;

  /// The background color of the AppBar.
  final Color? backgroundColor;

  /// The color of the leading icon (menu/back).
  final Color? leadingIconColor;

  /// The color of the action icons (search/notification/profile).
  final Color? actionIconColor;

  /// The default color for the title text and search text.
  final Color? textColor;

  /// The [TextStyle] for the main title text.
  final TextStyle? titleStyle;

  /// The [TextStyle] for the text entered in the search field.
  final TextStyle? searchTextStyle;

  /// The [TextStyle] for the hint text in the search field.
  final TextStyle? hintTextStyle;

  /// The size of the leading icon.
  final double leadingIconSize;

  /// The size of the action icons.
  final double actionIconSize;

  /// A custom widget to use as the profile avatar (e.g., [CircleAvatar]).
  final Widget? profileAvatar;

  /// List of items to display in a [PopupMenuButton] associated with the profile/actions.
  final List<PopupMenuEntry<dynamic>>? popupMenuItems;

  /// Called when an item is selected from the profile/action menu.
  final ValueChanged<dynamic>? onProfileMenuSelected;

  /// The number to display in the notification badge. If 0, no badge is shown.
  final int notificationCount;

  /// The hint text shown in the search input field.
  final String hintText;

  /// If true, the search bar remains open after the user submits the search query.
  final bool keepSearchOpenAfterSubmit;

  /// The icon used to switch to the search state. Defaults to [Icons.search].
  final IconData searchIcon;

  /// The icon used to close the search state. Defaults to [Icons.close].
  final IconData closeIcon;

  /// Creates a SearchableAppbar.
  const SearchableAppbar({
    super.key,
    this.title = "App Title",
    this.leadingIcon = Icons.menu,
    this.onSearch,
    this.onChanged,
    this.onLeadingPressed,
    this.backgroundColor,
    this.leadingIconColor,
    this.actionIconColor,
    this.textColor,
    this.titleStyle,
    this.searchTextStyle,
    this.hintTextStyle,
    this.leadingIconSize = 24.0,
    this.actionIconSize = 24.0,
    this.toolbarHeight = kToolbarHeight,
    this.titleAlignment = Alignment.centerLeft,
    this.bottomShape,
    this.bottom,
    this.profileAvatar,
    this.popupMenuItems,
    this.onProfileMenuSelected,
    this.notificationCount = 0,
    this.hintText = "Search...",
    this.keepSearchOpenAfterSubmit = false,
    this.searchIcon = Icons.search,
    this.closeIcon = Icons.close,
  });

  @override
  State<SearchableAppbar> createState() => _SearchableAppbarState();

  @override
  Size get preferredSize {
    double totalHeight = toolbarHeight;
    if (bottom != null) {
      totalHeight += bottom!.preferredSize.height;
    }
    return Size.fromHeight(totalHeight);
  }
}

/// The state class for [SearchableAppbar], managing the search state and animations.
class _SearchableAppbarState extends State<SearchableAppbar>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();
  late AnimationController _anim;
  late Animation<double> _expand;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expand = CurvedAnimation(
      parent: _anim,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _anim.forward().then((_) {
          // Request focus after the animation to ensure the keyboard pops up smoothly
          FocusScope.of(context).requestFocus(FocusNode());
        });
      } else {
        _controller.clear();
        widget.onChanged?.call('');
        FocusScope.of(context).unfocus();
        _anim.reverse();
      }
    });
  }

  void _submitSearch(String text) {
    final v = text.trim();
    if (v.isEmpty) return;
    widget.onSearch?.call(v);

    FocusScope.of(context).unfocus();

    if (!widget.keepSearchOpenAfterSubmit) {
      Future.delayed(const Duration(milliseconds: 50), () {
        _toggleSearch();
      });
    }
  }

  Widget _buildSearchField() {
    final Color defaultSearchTextColor =
        widget.textColor ?? _getThemeAwareDefaultColor(context);
    final TextStyle defaultSearchTextStyle =
        TextStyle(color: defaultSearchTextColor);

    // 0.7 * 255 = 178.5. Using 178 for alpha. This fixes the deprecated withOpacity issue.
    final TextStyle defaultHintStyle = defaultSearchTextStyle.copyWith(
      color: defaultSearchTextColor.withAlpha(178),
    );

    return FadeTransition(
      opacity: _expand,
      child: SizeTransition(
        sizeFactor: _expand,
        axisAlignment: -1.0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            style: widget.searchTextStyle ?? defaultSearchTextStyle,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintTextStyle ?? defaultHintStyle,
              border: InputBorder.none,
              suffixIcon: null,
            ),
            onChanged: widget.onChanged,
            onSubmitted: _submitSearch,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    final Color defaultTextColor =
        widget.textColor ?? _getThemeAwareDefaultColor(context);

    final TextStyle defaultTitleStyle = TextStyle(color: defaultTextColor);

    return Text(
      widget.title,
      style: widget.titleStyle ?? defaultTitleStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildNotificationIcon(Color effectiveActionIconColor) {
    if (widget.notificationCount == 0) {
      return Icon(Icons.notifications_none,
          color: effectiveActionIconColor, size: widget.actionIconSize);
    }

    return Stack(
      children: [
        Icon(Icons.notifications_none,
            color: effectiveActionIconColor, size: widget.actionIconSize),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: const BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: Text(
              widget.notificationCount > 9
                  ? '9+'
                  : widget.notificationCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildProfileButton(Color effectiveActionIconColor) {
    final bool hasAvatar = widget.profileAvatar != null;

    return IconButton(
      onPressed: () => widget.onProfileMenuSelected?.call(null),
      icon: hasAvatar
          ? widget.profileAvatar!
          : Icon(
              Icons.person,
              color: effectiveActionIconColor,
              size: widget.actionIconSize,
            ),
    );
  }

  /// Determines the default text/icon color based on the app's theme and AppBar background color.
  Color _getThemeAwareDefaultColor(BuildContext context) {
    final Brightness currentBrightness = Theme.of(context).brightness;

    // If a custom background color is provided, we assume the icon/text should be white for contrast.
    if (widget.backgroundColor != null) {
      // NOTE: Logic assumes a dark background if custom color is used, returning white for contrast.
      return Colors.white;
    } else {
      // Fallback to theme-aware default (black for light theme, white for dark theme)
      return currentBrightness == Brightness.dark ? Colors.white : Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color themeAwareDefaultColor = _getThemeAwareDefaultColor(context);

    final Color effectiveLeadingIconColor =
        widget.leadingIconColor ?? themeAwareDefaultColor;
    final Color effectiveActionIconColor =
        widget.actionIconColor ?? themeAwareDefaultColor;

    final List<Widget> actionsList = [];

    actionsList.add(
      IconButton(
        onPressed: _toggleSearch,
        icon: Icon(
          _isSearching ? widget.closeIcon : widget.searchIcon,
          color: effectiveActionIconColor,
          size: widget.actionIconSize,
        ),
      ),
    );

    if (!_isSearching) {
      if (widget.notificationCount > 0) {
        actionsList.add(
          IconButton(
            onPressed: () {},
            icon: _buildNotificationIcon(effectiveActionIconColor),
          ),
        );
      }

      if (widget.profileAvatar != null ||
          widget.onProfileMenuSelected != null) {
        actionsList.add(
          _buildProfileButton(effectiveActionIconColor),
        );
      }
    }

    return AppBar(
      backgroundColor: widget.backgroundColor,
      toolbarHeight: widget.toolbarHeight,
      shape: widget.bottomShape,
      bottom: widget.bottom,
      leading: IconButton(
        onPressed:
            _isSearching ? _toggleSearch : widget.onLeadingPressed ?? () {},
        icon: Icon(
          widget.leadingIcon,
          color: effectiveLeadingIconColor,
          size: widget.leadingIconSize,
        ),
      ),
      title: Align(
        alignment: widget.titleAlignment,
        child: _isSearching ? _buildSearchField() : _buildTitleText(),
      ),
      actions: actionsList,
    );
  }
}
