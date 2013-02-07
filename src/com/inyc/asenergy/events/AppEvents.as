package com.inyc.asenergy.events {
	import flash.events.EventDispatcher;			/**
	 * @author stevewarren
	 */
	public class AppEvents {
		/***************************************************
		* CORE FRAMEWORK EVENTS
		***************************************************/
		
		public static var CONFIG_LOADED:String = "CONFIG_LOADED";
		public static var LOG_MESSAGE:String = "LOG_MESSAGE";
		
		public static var SERVICES_READY:String = "SERVICES_READY";
		public static var SERVICE_RESULT:String = "SERVICE_RESULT";
		public static var SERVICE_FAILED:String = "SERVICE_FAILED";
		
		public static var USER_LOGGED_IN:String = "USER_LOGGED_IN";
		public static var USER_LOGGED_OUT:String = "USER_LOGGED_OUT";
		
		public static var SHOW_MODAL:String = "SHOW_MODAL";
		public static var CLOSE_MODAL:String = "CLOSE_MODAL";
		
		public static var SHOW_LOADER:String = "SHOW_LOADER";
		public static var LOADER_DISPLAYED:String = "LOADER_DISPLAYED";
		public static var HIDE_LOADER:String = "HIDE_LOADER";
		
		public static var SHOW_MESSAGE_DIALOG:String = "SHOW_MESSAGE_DIALOG";
		public static var DIALOG_BUTTON_CLICK:String = "DIALOG_BUTTON_CLICK";
		public static var DIALOG_DISPLAYED:String = "DIALOG_DISPLAYED";
		public static var DESTROY_DIALOG:String = "DESTROY_DIALOG";
		public static var DIALOG_OPEN:String = "DIALOG_OPEN";
		public static var DIALOG_CLOSE:String = "DIALOG_CLOSE";
		
		public static var LOAD_VIEW:String = "LOAD_VIEW";
		public static var VIEW_DISPLAYED:String = "VIEW_DISPLAYED";
		public static var DESTROY_VIEW:String = "DESTROY_VIEW";
		public static var VIEW_TRANSITION_FINISHED:String = "VIEW_TRANSITION_FINISHED";
		
		
		
		public static var ANIM_FINISHED:String = "ANIM_FINISHED";
		public static var THUMBNAIL_LOADED:String = "THUMBNAIL_LOADED";
		
		
		
		
		/***************************************************
		* SEQUENCER EVENTS
		***************************************************/
		
		public static var SEQUENCER_FINISHED:String = "SEQUENCER_FINISHED";
		public static var SEQUENCER_EVENT:String = "SEQUENCER_EVENT";
		public static var SEQUENCER_TIME_STAMP:String = "SEQUENCER_TIME_STAMP";
		
		
		/***************************************************
		* CORE DESIGN TOOL EVENTS
		***************************************************/
		
		public static var NEW_DOCUMENT:String = "NEW_DOCUMENT";
		public static var OPEN_DOCUMENT:String = "OPEN_DOCUMENT";
		public static var OPEN_DOCUMENT_BROWSER:String = "OPEN_DOCUMENT_BROWSER";
		public static var CLOSE_DOCUMENT:String = "CLOSE_DOCUMENT";
		public static var SAVE_DOCUMENT:String = "SAVE_DOCUMENT";
		public static var SAVE_AS_DOCUMENT:String = "SAVE_AS_DOCUMENT";
		public static var DELETE_DOCUMENT:String = "DELETE_DOCUMENT";
		
		public static var DOCUMENT_OPENED:String = "DOCUMENT_OPENED";
		public static var DOCUMENT_RENDERED:String = "DOCUMENT_RENDERED";
		public static var DOCUMENT_CLOSED:String = "DOCUMENT_CLOSED";
		public static var DOCUMENT_SAVED:String = "DOCUMENT_SAVED";
		public static var DOCUMENT_DELETED:String = "DOCUMENT_DELETE";
		
		public static var ADD_LAYOUT_ITEM:String = "ADD_LAYOUT_ITEM";
		public static var LAYOUT_ITEM_READY:String = "LAYOUT_ITEM_READY";
		public static var LAYOUT_ITEM_SELECTED:String = "LAYOUT_ITEM_SELECTED";
		public static var LAYOUT_ITEM_SET_SELECTED:String = "LAYOUT_ITEM_SET_SELECTED";
		public static var LAYOUT_ITEM_DELETED:String = "LAYOUT_ITEM_DELETED";
		public static var LAYOUT_ITEM_DESELECTED:String = "LAYOUT_ITEM_DESELECTED";
		public static var LAYOUT_ITEM_LOADED:String = "LAYOUT_ITEM_LOADED";
		
		/***************************************************
		* TOOLBAR
		***************************************************/
		
		public static var SHAPE_CHANGE:String = "SHAPE_CHANGE";
		public static var SHAPE_FILTERS:String = "SHAPE_FILTERS";
		public static var SHAPE_GROW:String = "SHAPE_GROW";
		public static var SHAPE_SHRINK:String = "SHAPE_SHRINK";
		public static var SHAPE_CW:String = "SHAPE_CW";
		public static var SHAPE_CCW:String = "SHAPE_CCW";
		public static var SHAPE_FLIPH:String = "SHAPE_FLIPH";
		public static var SHAPE_FLIPV:String = "SHAPE_FLIPV";
		public static var SHAPE_FORWARD:String = "SHAPE_FORWARD";
		public static var SHAPE_BACKWARD:String = "SHAPE_BACKWARD";
		public static var SHAPE_TRASH:String = "SHAPE_TRASH";
		
		/***************************************************
		* COMPONENT EVENTS
		***************************************************/
		
		public static var CAROUSEL_ITEM_CLICKED:String = "CAROUSEL_ITEM_CLICKED";
		public static var GRID_ITEM_CLICKED:String = "GRID_ITEM_CLICKED";
		public static var IMAGE_GRID_CLICK:String = "IMAGE_GRID_CLICK";
		public static var BUTTON_CLICK:String = "BUTTON_CLICK";
		
		/***************************************************
		* TOUCH OBJECT EVENTS
		***************************************************/
		
		public static var TOUCH_OBJECT_CLICKED:String = "TOUCH_OBJECT_CLICKED";
		public static var TOUCH_OBJECT_DOUBLE_CLICKED:String = "TOUCH_OBJECT_DOUBLE_CLICKED";
		
		public static var TOUCH_OBJECT_START_DRAG:String = "TOUCH_OBJECT_START_DRAG";
		public static var TOUCH_OBJECT_STOP_DRAG:String = "TOUCH_OBJECT_STOP_DRAG";

		public static var TOUCH_OBJECT_START_ZOOM:String = "TOUCH_OBJECT_START_ZOOM";
		public static var TOUCH_OBJECT_START_ROTATE:String = "TOUCH_OBJECT_START_ROTATE";
		public static var TOUCH_OBJECT_SWIPE:String = "TOUCH_OBJECT_SWIPE";
		
		
		/***************************************************
		* SCHNEIDER EVENTS
		***************************************************/
		
		public static var CONTENT_NEXT:String = "CONTENT_NEXT";
		public static var CONTENT_PREVIOUS:String = "CONTENT_PREVIOUS";
		public static var CONTENT_CLOSE:String = "CONTENT_CLOSE";
		public static var CONTENT_SEEIT:String = "CONTENT_SEEIT";
		
		public static var SHOW_EMAIL_FORM:String = "SHOW_EMAIL_FORM";
		
		public static var CONTACT_FIELD_1_SELECTED:String = "CONTACT_FIELD_1_SELECTED";
		public static var CONTACT_FIELD_2_SELECTED:String = "CONTACT_FIELD_2_SELECTED";
		public static var CONTACT_FIELD_3_SELECTED:String = "CONTACT_FIELD_3_SELECTED";
		public static var CONTACT_SUBMIT:String = "CONTACT_SUBMIT";
		public static var CONTACT_CLOSE:String = "CONTACT_CLOSE";
		
	}
}
