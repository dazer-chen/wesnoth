/*
   Copyright (C) 2008 - 2016 by Mark de Wever <koraq@xs4all.nl>
   Part of the Battle for Wesnoth Project http://www.wesnoth.org/

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY.

   See the COPYING file for more details.
*/

#ifndef GUI_WIDGETS_TOGGLE_BUTTON_HPP_INCLUDED
#define GUI_WIDGETS_TOGGLE_BUTTON_HPP_INCLUDED

#include "gui/widgets/control.hpp"
#include "gui/widgets/selectable.hpp"

namespace gui2
{

// ------------ WIDGET -----------{

/**
 * Class for a toggle button.
 *
 * A toggle button is a button with two states 'up' and 'down' or 'selected' and
 * 'deselected'. When the mouse is pressed on it the state changes.
 */
class toggle_button : public control, public selectable_item
{
public:
	toggle_button();

	/***** ***** ***** ***** Inherited ***** ***** ***** *****/

	/** See @ref control::set_members. */
	void set_members(const string_map& data) override;

	/** See @ref control::set_active. */
	virtual void set_active(const bool active) override;

	/** See @ref control::get_active. */
	virtual bool get_active() const override;

	/** See @ref control::get_state. */
	virtual unsigned get_state() const override;

	/** Inherited from control. */
	void update_canvas() override;

	/** Inherited from selectable_item */
	unsigned get_value() const override
	{
		return state_num_;
	}
	/** Inherited from selectable_item */
	unsigned num_states() const override;
	/** Inherited from selectable_item */
	void set_value(const unsigned selected) override;

	/***** ***** ***** setters / getters for members ***** ****** *****/

	void set_retval(const int retval);

	/** Inherited from selectable_item. */
	void set_callback_state_change(std::function<void(widget&)> callback) override
	{
		callback_state_change_ = callback;
	}

	void set_icon_name(const std::string& icon_name)
	{
		icon_name_ = icon_name;
		update_canvas();
	}
	const std::string& icon_name() const
	{
		return icon_name_;
	}

private:
	/**
	 * Possible states of the widget.
	 *
	 * Note the order of the states must be the same as defined in settings.hpp.
	 * Also note the internals do assume the order for 'up' and 'down' to be the
	 * same and also that 'up' is before 'down'. 'up' has no suffix, 'down' has
	 * the SELECTED suffix.
	 */
	enum state_t {
		ENABLED,
		DISABLED,
		FOCUSED,
		COUNT
	};

	void set_state(const state_t state);

	/**
	 * Current state of the widget.
	 *
	 * The state of the widget determines what to render and how the widget
	 * reacts to certain 'events'.
	 */
	state_t state_;
	/**
	 *	Usually 1 for selected and 0 for not selected, can also have higher values in tristate buttons.
	 */
	unsigned state_num_;
	/**
	 * The return value of the button.
	 *
	 * If this value is not 0 and the button is double clicked it sets the
	 * retval of the window and the window closes itself.
	 */
	int retval_;

	/** See selectable_item::set_callback_state_change. */
	std::function<void(widget&)> callback_state_change_;

	/**
	 * The toggle button can contain an icon next to the text.
	 * Maybe this will move the the control class if deemed needed.
	 */
	std::string icon_name_;

	/** See @ref control::get_control_type. */
	virtual const std::string& get_control_type() const override;

	/***** ***** ***** signal handlers ***** ****** *****/

	void signal_handler_mouse_enter(const event::event_t event, bool& handled);

	void signal_handler_mouse_leave(const event::event_t event, bool& handled);

	void signal_handler_left_button_click(const event::event_t event,
										  bool& handled);

	void signal_handler_left_button_double_click(const event::event_t event,
												 bool& handled);
};

// }---------- DEFINITION ---------{

struct toggle_button_definition : public control_definition
{
	explicit toggle_button_definition(const config& cfg);

	struct tresolution : public resolution_definition
	{
		explicit tresolution(const config& cfg);
	};
};

// }---------- BUILDER -----------{

namespace implementation
{

struct builder_toggle_button : public builder_control
{
	explicit builder_toggle_button(const config& cfg);

	using builder_control::build;

	widget* build() const;

private:
	std::string icon_name_;
	std::string retval_id_;
	int retval_;
};

} // namespace implementation

// }------------ END --------------

} // namespace gui2

#endif
