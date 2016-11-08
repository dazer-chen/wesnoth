/*
   Copyright (C) 2016 by the Battle for Wesnoth Project http://www.wesnoth.org/

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY.

   See the COPYING file for more details.
*/

#ifndef GUI_WIDGETS_UNIT_PREVIEW_PANE_HPP_INCLUDED
#define GUI_WIDGETS_UNIT_PREVIEW_PANE_HPP_INCLUDED

#include "gui/widgets/container.hpp"

#include <string>

class unit;
class unit_type;

namespace gui2
{

// ------------ WIDGET -----------{

class button;
class image;
class label;
class tree_view;
class tree_view_node;

namespace implementation
{
	struct builder_unit_preview_pane;
}

class unit_preview_pane : public container_base
{
	friend struct implementation::builder_unit_preview_pane;

public:
	unit_preview_pane()
		: container_base(1)
		, current_type_()
		, icon_type_(nullptr)
		, icon_race_(nullptr)
		, icon_alignment_(nullptr)
		, label_name_(nullptr)
		, label_level_(nullptr)
		, label_race_(nullptr)
		, label_details_(nullptr)
		, label_details_minimal_(nullptr)
		, tree_details_(nullptr)
		, button_profile_(nullptr)
		, image_mods_()
	{
	}

	/** Displays the stats of a specified unit type */
	void set_displayed_type(const unit_type& type);

	/** Displays the stats of a specific unit */
	void set_displayed_unit(const unit& u);

	/** Sets the facing of the unit image */
	void set_image_mods(const std::string& mods);

	/** Callback for the profile button */
	void profile_button_callback();

	/** See @ref control::set_active. */
	virtual void set_active(const bool active) override;

	/** See @ref control::get_active. */
	virtual bool get_active() const override;

	/** See @ref control::get_state. */
	virtual unsigned get_state() const override;

protected:
	/**
	 * Initializes the interneral sub-widget pointers.
	 * Should be called when building the window, so the pointers
	 * are initilized when set_displayed_type() is called.
	 */
	void finalize_setup();

private:
	std::string current_type_;

	image* icon_type_;
	image* icon_race_;
	image* icon_alignment_;

	label* label_name_;
	label* label_level_;
	label* label_race_;

	control* label_details_;
	control* label_details_minimal_;
	tree_view* tree_details_;

	button* button_profile_;

	std::string image_mods_;

	template<typename T> // This is only a template to avoid including units/attack.hpp
	void print_attack_details(T attacks, tree_view_node& parent_node);

	enum state_t {
		ENABLED
	};

	/** See @ref control::get_control_type. */
	virtual const std::string& get_control_type() const override;

	/** See @ref container_base::set_self_active. */
	virtual void set_self_active(const bool active) override;

};

// }---------- DEFINITION ---------{

struct unit_preview_pane_definition : public control_definition
{

	explicit unit_preview_pane_definition(const config& cfg);

	struct tresolution : public resolution_definition
	{
		explicit tresolution(const config& cfg);

		builder_grid_ptr grid;
	};
};

// }---------- BUILDER -----------{

namespace implementation
{

struct builder_unit_preview_pane : public builder_control
{
public:
	explicit builder_unit_preview_pane(const config& cfg);

	using builder_control::build;

	widget* build() const;

private:
	const std::string image_mods_;
};

} // namespace implementation

// }------------ END --------------

} // namespace gui2

#endif
