(function($, window, document) {
	"use strict";

	/**
	*	Purchase Module
	**/
	App.Purchases = (function () {

		var indicatePurchased;

		function init() {
			indicatePurchased = $('.purchase-notify');
			applyPurchaseClick();
		}

		function changeToPurchased(event) {
			var id = $(this).attr('meta-purchase'),
				t = this,
				parent = $(t).parent();

			$.ajax({
				type : "POST",
				url : "/purchaseitem",
				dataType: 'text',
				data: { id : id}
			}).done(function (responseText) {
				hideLineItem(parent);
			}).fail(function (data) { 
				$(t).addClass("purchase-error");
				$(t).text("ERROR");
			});
		}

		function applyPurchaseClick() {
			indicatePurchased = $('.purchase-notify');
			indicatePurchased.click(changeToPurchased);
		}

		// Expects jQuery Object
		function hideLineItem(obj) {
			obj.animate({"opacity" : 0.0}, 500, function (){
				$(this).animate({"height" : '0px'}, 250, function (obj) {
					$(this).remove();
				});
			});
		}

		return {
			init : init,
			applyPurchaseClick : applyPurchaseClick
		};

	})();


	/**
	*	Form Handlers
	**/
	new App.FormResponse('new_purchase', 
		function(data) {
			var success = $('#'+this.id).find('.form-success');
			success.append("<div>New Purchase Created</div>");
			success.fadeIn('fast');
			setTimeout(function () {
				success.fadeOut(500, function () {
					success.html('');
				});

			}, 1500);
			App.Dashboard.loadPurchaseData();
		},
		function (data) {
			var error = $('#' + this.id).find('.form-error');
			error.html('<div>'+ data.message +'</div>');
			error.fadeIn();
			setTimeout(function () {
				error.fadeOut(500, function () {
					error.html('');
				});
			}, 1500);
		}
	);	

	new App.FormResponse('edit_purchase', 
		function(data) {
			var success = $('#'+this.id).find('.form-success');
			success.append("<div>Purchase Updated</div>");
			success.fadeIn('fast');
			setTimeout(function () {
				success.fadeOut(500, function () {
					success.html('');
				});

			}, 1500);
		},
		function (data) {
			var error = $('#' + this.id).find('.form-error');
			error.html('<div>'+ data.message +'</div>');
			error.fadeIn();
			setTimeout(function () {
				error.fadeOut(500, function () {
					error.html('');
				});
			}, 1500);
		},
		['edit']
	);

}(jQuery, this, this.document));