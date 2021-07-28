(function ($) {
    'use strict';
    $(document).ready(() => {
        /*********************
         * Home Setting Save
         * */
        $(document).on('click', '#mn-admin-setting', function () {

            let _this = $(this);
            let $inputs = $('form#mn-admin-panel :input');
            let dashboardPostData = getFormData($inputs);

            postAjax(_this, 'post_mn_admin_data', dashboardPostData, (success, response) => {
                if (response.status && response.status === true) {
                    swal("Social Links Data Saved Successfully", " ", "success",{
                        buttons: false,
                        timer: 1000,
                    });
                } else {
                    swal("Fail To Save", "Refresh your page and try again", "error",{
                        buttons: false,
                        timer: 1000,
                    });
                }
            });
        });

        $(document).find('.mn-multiple-checkboxes').selectpicker();
    });

    function getFormData($inputs) {
        let values = {};
        $inputs.each(function () {
            if (this.name.includes('[]')) {
                let key = String(this.name).replace('[]', '');
                if(this.type === "checkbox"){
                    console.log(this,$(this).is(':checked'));
                    if (!(key in values)) {
                        values[key] = [];
                    }
                    if($(this).is(':checked')){
                        values[key].push($(this).val());
                    }else{
                        values[key].push(null);
                    }
                }else{
                    if (!(key in values)) {
                        values[key] = [];
                    }
                    values[key].push($(this).val());
                }
            } else {
                if( this.type === "checkbox" ){
                    console.log(this,$(this).is(':checked'));
                    if($(this).is(':checked')){
                        values[this.name] = $(this).val();
                    }else{
                        values[this.name] = null;
                    }
                }else {
                    values[this.name] = $(this).val();
                }
            }
        });
        return values;
    }

    /***************************
     * Post Ajax With Callback
     * @param _this
     * @param action
     * @param type
     * @param postData
     * @param callback
     */
    function postAjax(_this, action, postData, callback) {
        $.ajax({
            url: mn_localize.ajaxurl,
            type: "post",
            data: {
                action: action,
                _ajax_nonce: mn_localize.nonce,
                fields: postData
            },
            beforeSend: function () {
                _this.html(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 48 48"><circle cx="24" cy="4" r="4" fill="#fff"/><circle cx="12.19" cy="7.86" r="3.7" fill="#fffbf2"/><circle cx="5.02" cy="17.68" r="3.4" fill="#fef7e4"/><circle cx="5.02" cy="30.32" r="3.1" fill="#fef3d7"/><circle cx="12.19" cy="40.14" r="2.8" fill="#feefc9"/><circle cx="24" cy="44" r="2.5" fill="#feebbc"/><circle cx="35.81" cy="40.14" r="2.2" fill="#fde7af"/><circle cx="42.98" cy="30.32" r="1.9" fill="#fde3a1"/><circle cx="42.98" cy="17.68" r="1.6" fill="#fddf94"/><circle cx="35.81" cy="7.86" r="1.3" fill="#fcdb86"/></svg><span>Saving Data..</span>'
                );
            },
            success: function (response) {
                _this.html("Submit");
                if (typeof callback == "function") {
                    callback(true, response);
                }
            },
            error: function () {
                _this.html("Submit");
                if (typeof callback == "function") {
                    callback(false, null);
                }
            }
        });
    }
})(jQuery);