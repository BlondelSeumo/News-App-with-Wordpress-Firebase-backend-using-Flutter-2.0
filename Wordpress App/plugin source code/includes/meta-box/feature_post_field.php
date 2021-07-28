<?php
add_filter( 'rwmb_meta_boxes', 'mighty_meta_boxes' );
function mighty_meta_boxes( $meta_boxes ) {	

	// Product Member Details In Class
	$meta_boxes[] = array(
		'title'			=> esc_html__( 'Post Data','mighty-api-lang' ),
		'post_types'	=> 'post',
		'fields'		=> array(
					
			array(
				'id'		=> 'mn_is_featured',
				'name'		=> esc_html__( 'Set as Breaking :','mighty-api-lang' ),		
				'type'		=> 'checkbox'    
			),
			array(
				'type'	=>'divider',
			),
			array(
				'id'		=> 'mn_is_story',
				'name'		=> esc_html__( 'Set as Story :','mighty-api-lang' ),		
				'type'		=> 'checkbox'    
			),
			array(
				'type'	=>'divider',
			),
		),
	);

	
		
	
	return $meta_boxes;
}
?>
