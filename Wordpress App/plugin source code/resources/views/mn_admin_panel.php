<?php
$news_option = get_option('news_option');
$categories = mnGetCategory();
?>
<div class="row mr-lg-0" id="mn-admin-option-accordion">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <span class="h5"><?php echo esc_html__('Mighty Plugin', 'mighty-news-api-lang') ?></span>
                <small class="text-muted ml-2"><?php echo esc_html__('v ' . MIGHTYNEWS_API_VERSION, 'mighty-news-api-lang') ?></small>
            </div>
            <div class="card-body p-0 mt-2">
                <div class="card p-0">
                    <div class="card-header">
                        <?php echo esc_html__('App Dashboard', 'mighty-news-api-lang') ?>
                    </div>
                    <div class="card-body">
                        <form name="mn-admin-panel" id="mn-admin-panel" enctype="multipart/form-data">
                        
                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="whatsapp"><?php echo esc_html__('WhatsApp', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="whatsapp" name="whatsapp" value="<?php echo isset($news_option['whatsapp']) ? $news_option['whatsapp'] : null ; ?>">
                                    <small class="help-block">
                                        <ul class="list-unstyled">
                                            <li><b>Please Enter Number With Country Code</b></li>
                                            <li>For e.g. 919876543210</li>
                                            <li>91 Is Country Code</li>
                                        </ul>
                                    </small>
                                </div>
                            </div>
                            
                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" ><?php echo esc_html__('Category', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <select class="form-control mn-multiple-checkboxes" multiple name="selected_category" data-live-search="true" data-actions-box="true" x-placement="Select Category">
                                        <?php
                                            foreach ($categories as $category) {
                                                echo '<option value="' . $category['value'] . '" ' . (!empty($news_option['selected_category']) && in_array($category['value'], $news_option['selected_category']) ? 'selected' : '') . ' >' . $category['text'] . '</option>';
                                            }
                                        ?>
                                    </select>
                                </div>    
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="disable_ad"><?php echo esc_html__('Disable Ads', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="checkbox" class="form-control" id="disable_ad" name="disable_ad" value="false" <?php echo isset($news_option['disable_ad']) &&  $news_option['disable_ad'] == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this option for disabling ads</b></span>
                                </div>
                            </div>
                            
                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="disable_location"><?php echo esc_html__('Disable Location', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="checkbox" class="form-control" id="disable_location" name="disable_location" value="false" <?php echo isset($news_option['disable_location']) &&  $news_option['disable_location'] == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this option for disabling location</b></span>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="disable_twitter"><?php echo esc_html__('Disable Twitter', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="checkbox" class="form-control" id="disable_twitter" name="disable_twitter" value="false" <?php echo isset($news_option['disable_twitter']) &&  $news_option['disable_twitter'] == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this option for disabling twitter</b></span>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="disable_sticky_post"><?php echo esc_html__('Ignore Sticky Post', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="checkbox" class="form-control" id="disable_sticky_post" name="disable_sticky_post" value="true" <?php echo isset($news_option['disable_sticky_post']) &&  $news_option['disable_sticky_post'] == false ? null : 'checked' ;  ?>> <span class="small"><b>Enable this option for ignore sticky post</b></span>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="disable_cryptocurrency"><?php echo esc_html__('Disable Crypto Currency', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="checkbox" class="form-control" id="disable_cryptocurrency" name="disable_cryptocurrency" value="false" <?php echo isset($news_option['disable_cryptocurrency']) &&  $news_option['disable_cryptocurrency'] == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this option for disabling crypto currency</b></span>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="disable_headline"><?php echo esc_html__('Disable Headline Slider', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="checkbox" class="form-control" id="disable_headline" name="disable_headline" value="false" <?php echo isset($news_option['disable_headline']) &&  $news_option['disable_headline'] == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this option for disabling headline slider</b></span>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="disable_story"><?php echo esc_html__('Disable Story', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="checkbox" class="form-control" id="disable_story" name="disable_story" value="false" <?php echo isset($news_option['disable_story']) &&  $news_option['disable_story'] == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this option for disabling story</b></span>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="disable_quickread"><?php echo esc_html__('Disable Quick Read', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="checkbox" class="form-control" id="disable_quickread" name="disable_quickread" value="false" <?php echo isset($news_option['disable_quickread']) &&  $news_option['disable_quickread'] == true ? 'checked' : null ;  ?>> <span class="small"><b>Enable this option for disabling quick read</b></span>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="facebook"><?php echo esc_html__('Facebook', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="facebook" name="facebook" value="<?php echo isset($news_option['facebook']) ? $news_option['facebook'] : null ; ?>">
                                </div>
                            </div>
                            
                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="twitter"><?php echo esc_html__('Twitter', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="twitter" name="twitter" value="<?php echo isset($news_option['twitter']) ? $news_option['twitter'] : null ; ?>">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="instagram"><?php echo esc_html__('Instagram', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="instagram" name="instagram" value="<?php echo isset($news_option['instagram']) ? $news_option['instagram'] : null ; ?>">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="contact" name="contact"><?php echo esc_html__('Support Email', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="contact" name="contact" value="<?php echo isset($news_option['contact']) ? $news_option['contact'] : null ; ?>">
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="privacy_policy"><?php echo esc_html__('Privacy Policy Url', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="privacy_policy" name="privacy_policy" value="<?php echo isset($news_option['privacy_policy']) ? $news_option['privacy_policy'] : null ; ?>">
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="term_condition"><?php echo esc_html__('Term & Condition Url', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="term_condition" name="term_condition" value="<?php echo isset($news_option['term_condition']) ? $news_option['term_condition'] : null ; ?>">
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-2 align-self-center mb-0" for="copyright_text"><?php echo esc_html__('Copyright Text', 'mighty-news-api-lang') ?></label>
                                <div class="col-sm-6">
                                    <textarea class="form-control" id="copyright_text" name="copyright_text"><?php echo isset($news_option['copyright_text']) ? $news_option['copyright_text'] : null ; ?></textarea>
                                </div>
                            </div>

                            <div class="form-group">
                                <hr class="mb-3">
                                <button type="button" class="btn btn-info mt-2" id="mn-admin-setting">
                                    <?php echo esc_html__('Submit', 'mighty-news-api-lang') ?>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
