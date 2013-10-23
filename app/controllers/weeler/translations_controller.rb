module Weeler
  class TranslationsController < BaseController
    
    def index
      @translations = translations_by_params
      @translations = @translations.page(params[:page]).per(20)
      @groups = I18n::Backend::Weeler::Translation.groups
    end
    
    def new
      @translation = I18n::Backend::Weeler::Translation.new
    end

    def edit
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])
    end

    def create
      @translation = I18n::Backend::Weeler::Translation.new(translation_params)
      if @translation.save
        redirect_to edit_weeler_translation_path(@translation), flash: {success: "Translation saved."}
      else
        flash.now[:error] = "Errors in saving."
        render :edit
      end
    end

    def update
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])
      if @translation.update_attributes(translation_params)
        redirect_to edit_weeler_translation_path(@translation), flash: {success: "Translation updated."}
      else
        flash.now[:error] = "Errors in updating."
        render :edit
      end
    end

    def destroy
      @translation = I18n::Backend::Weeler::Translation.find(params[:id])
      @translation.destroy
      redirect_to weeler_translations_path, flash: {success: "Translation succesfully removed."}
    end

    def export
      require( 'axlsx' )

      # construct xlsx file
      p = Axlsx::Package.new
      # Numbers requires this
      p.use_shared_strings = true
      
      sheet = p.workbook.add_worksheet(name: "translations")

      # All used locales and translations by params
      locales = I18n::Backend::Weeler::Translation.available_locales
      locales = locales.select{ |l| l.present? }
      @translations = translations_by_params

      # title row
      row = [ 'Key' ]
      locales.each do |locale|
        row.push(locale.capitalize)
      end

      sheet.add_row(row)

      @translations.each do |translation|
        row = [ translation.key ]
        locales.each do |locale|
          result = I18n::Backend::Weeler::Translation.locale(locale).lookup(translation.key).load
          if result.first.present?
            row.push(result.first.value)
          else
            row.push("")
          end
        end

        sheet.add_row(row)
      end

      respond_to do |format|
        format.xlsx do
          outstrio = StringIO.new
          outstrio.write(p.to_stream.read)
          send_data(outstrio.string, filename: "translations" + '.xlsx')
        end
      end

    end

    def import
      require "roo"
      xls = Roo::Excelx.new(params[:file].tempfile.path, file_warning: :ignore)

      xls.each_with_pagename do |name, sheet|
        
        # Lookup locales
        locales = []
        sheet.row(1).each_with_index do |cell, i|
          if i > 0
            locales.push(cell.downcase)
          end
        end

        # Lookup values
        (2..sheet.last_row).each do |row_no|
          locale = nil
          key = nil
          value = nil
          sheet.row(row_no).each_with_index do |cell, i|
            if i == 0
              key = cell
            else
              locale = locales[ i - 1 ]
              value = cell.nil? ? '' : cell

              p "> Readed: #{locale}.#{key} = #{value} "
              if locale.present? && key.present?
                translation = I18n::Backend::Weeler::Translation.find_or_initialize_by locale: locale, key: key
                if translation.value != value
                  translation.value = value
                  translation.save
                end
              end

            end
          end # cells

        end # rows

      end # sheets
      redirect_to weeler_translations_path, flash: {success: "Translations succesfully imported."}
    end

    private

      def translation_params
        params.require(:i18n_backend_weeler_translation).permit([:locale, :key, :value, :is_proc, :interpolations => []])
      end

      def translations_by_params
        translations = I18n::Backend::Weeler::Translation.order("locale, key")

        translations = translations.where("key LIKE ?", "%#{params[:query]}%") if params[:query] 
        translations = translations.where(locale: params[:locale]) if params[:locale].present?
        translations = translations.lookup(params[:group]) if params[:group].present?
        translations
      end

  end
end