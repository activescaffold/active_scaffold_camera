module ActiveScaffoldCamera
  module ViewHelpers
    I18N_ATTRIBUTES = [:video_not_supported, :audio_not_supported, :media_forbidden]
    def snapshot_attributes(column)
      attributes = Hash[I18N_ATTRIBUTES.map{ |attr| [attr, column.options[attr] || attr] }]
      attributes[:source] = column.options[:source] if column.options[:source]
      I18N_ATTRIBUTES.each { |attr| attributes[attr] = as_(attributes[attr]) if attributes[attr].is_a? Symbol }
      attributes
    end

    def active_scaffold_input_snapshot(column, html_options)
      content_tag :div, '', :class => "snapshot-input #{html_options[:class]}", :id => html_options[:id], :data => snapshot_attributes(column)
    end

    def active_scaffold_column_snapshot(record, column)
      
    end
  end
end
