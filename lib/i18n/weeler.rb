require 'i18n'

require 'i18n/humanize_missing_translations'
I18n.exception_handler.extend I18n::HumanizeMissingTranslations

require 'i18n/backend/weeler'
weeler_i18n_backend = I18n::Backend::Weeler.new
weeler_i18n_backend.i18n_cache = Weeler.i18n_cache
I18n.backend = I18n::Backend::Chain.new(weeler_i18n_backend, I18n::Backend::Simple.new)

logger = Logger.new(STDOUT)
logger.info "Weeler i18n backend loaded"
