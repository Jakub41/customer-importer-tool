# frozen_string_literal: true

class CompaniesController < ApplicationController
  def upload
  end

  def bulk_upload
    return render_errors('Company or File not present.') if company.blank? || file.blank?

    if service_result.success?
      flash[:message] = service_result.messages[0]
      flash[:results] = parse_results(service_result.object[:results])

      redirect_to company_customers_path(service_result.object[:company].id)
    else
      render_errors service_result.error
    end
  end

  private

  def company
    customer_import_params[:company_name]
  end

  def file
    customer_import_params[:file]
  end

  def customer_import_params
    params.permit(:file, :company_name)
  end

  def parse_results(data)
    data.try(:flatten).try(:join, ', ')
  end

  def service_result
    @service_result ||= Companies::Importer::Document.new(file: file, company: company).call
  end

  def render_errors(error)
    flash[:error] = error
    redirect_to upload_companies_path
  end
end
