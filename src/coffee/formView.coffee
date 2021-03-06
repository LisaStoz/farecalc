class FareCalculator.FormView extends Backbone.View

  el: '.main'

  events:
    'submit .journey-form': 'submit'
    'keyup  #from, #to': 'suggestStations'
    'blur #from, #to': 'removeDropdown'
    'focus #from, #to': 'suggestStations'
    'click #toggle-weekdays': 'toggleWeekdays'

  template: _.template($('.journey-form-template').html())

  submit: (e)->
    e.preventDefault()
    FareCalculator.formView.resetErrors()
    FareCalculator.resultsView.cleanup()
    that = this
    fieldValues = {
      "from": $("#from").val()
      "to": $('#to').val()
      "days": (()->
        checked = ""
        $('[name="days"]').each(
          ()->
            if $(this).is(':checked') then checked+="1" else checked+="0"
        )
        checked
      )()
      "onwards": $("#onwards").val()
      "return": $("#return").val()
      "discount": $("#discount").val()
    }
    FareCalculator.formModel = new FareCalculator.FormModel(fieldValues)

  suggestStations: (e)->
    if $(e.target).val().length > 0
      if not FareCalculator.stationsView?
        FareCalculator.stationsView = new FareCalculator.StationsView
        FareCalculator.stationsView.render($(e.target))
      FareCalculator.stationsView.update($(e.target))
    else
      this.removeDropdown()

  render: ->
    if this.$el.find('.journey-form').length is 0
       this.$el.append(this.template())
    this

  removeDropdown: ()->
    removeIt = ->
      FareCalculator.stationsView?.setElement('.dropdown').remove()
      FareCalculator.stationsView = undefined
    setTimeout(removeIt, 100)

  toggleWeekdays: (e)->
    e.preventDefault()

    if $('.week-days input:checked').length < 5
      $('.week-days input').prop('checked', true)
      $(e.target).text('Un-check all weekdays')
    else
      $('.week-days input').prop('checked', false)
      $(e.target).text('Check all weekdays')

  resetErrors: ()->
    ['from', 'to', 'days'].forEach(
      (field)->
        $("#help-#{field}").text("")
        $("#help-#{field}").closest('.form-group').removeClass('has-error')
    )

  showErrors: ( errors )->
    errors.forEach (
      (error)->
        $("#help-#{error.field}").text( error.msg )
        $("#help-#{error.field}").closest('.form-group').addClass('has-error')
    )
