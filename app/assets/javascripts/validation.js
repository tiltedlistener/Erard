 (function($, window, document) {
	"use strict";

	/**
	*	Test Class
	**/
	App.FormValidationTest = function (name, type, logic, msg) {

		this.init = function(name, type, logic, msg) {
			this.logicTest = logic;
			this.message = msg;
			this.name = name;

			if (Array.isArray(type)) {
				var len = type.length;
				for(var i=1;i<len;i++) {
					new App.FormValidationTest(name, type[i], logic, msg);
				}
				this.type = type[0];
			} else
				this.type = type;

			App.Form.addTest(this);
		};

		this.run = function (val) {

			if(this.logicTest(val))
				return [true];
			else {
				return [false, this.message];
			}
		};

		this.init(name, type, logic, msg);
	};


	/**
	*	Basic Tests
	**/
	new App.FormValidationTest(
		'textLength', 
		['textarea','input[type="text"]'], 
		function (val){
			if (val.length < 4)
				return false;
			else
				return true;
		}, 
		"Text is too short.");

	new App.FormValidationTest(
		'numbersOnly', 
		['input.numbers'], 
		function (val){
			var converted = val.match(/\d/gi);
			if (converted === null )
				return false;
			else {
				if (converted.length == val.length)
					return true;
				else 
					return false;
			}
		}, 
		"Numbers Only.");
	new App.FormValidationTest(
		'required', 
		['input.required'], 
		function (val){
			if (val.length <= 0)
				return false;
			else
				return true;
		}, 
		"Required.");	



}(jQuery, this, this.document));