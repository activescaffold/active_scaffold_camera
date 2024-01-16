module ActiveScaffoldCamera
  module ViewHelpers
    I18N_ATTRIBUTES = [:video_not_supported, :audio_not_supported, :media_forbidden]
    def snapshot_attributes(column, ui_options: column.options)
      attributes = Hash[I18N_ATTRIBUTES.map{ |attr| [attr, ui_options[attr] || attr] }]
      attributes[:source] = ui_options[:source] if ui_options[:source]
      I18N_ATTRIBUTES.each { |attr| attributes[attr] = as_(attributes[attr]) if attributes[attr].is_a? Symbol }
      attributes
    end

    def active_scaffold_input_snapshot(column, html_options, ui_options: column.options)
      content_tag :div, :class => "snapshot-input #{html_options[:class]}", :id => html_options[:id], :data => snapshot_attributes(column, ui_options: ui_options) do
        hidden_field :record, column.name, :name => html_options[:name]
      end
    end

    def active_scaffold_column_snapshot(record, column, ui_options: column.options)
      value = record.send(column.name)
      tag :img, :src => value if value
    end
  end
end
