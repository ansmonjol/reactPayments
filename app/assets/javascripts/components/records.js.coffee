# Records logic
@Records = React.createClass
  # Init records array
  getInitialState: ->
    records: @props.data

  # Default array
  getDefaultProps: ->
    records: []


  # Add a record in the records array
  addRecord: (record) ->
    records = React.addons.update(@state.records, { $push: [record] })
    @setState records: records

  # Remove record on records array
  deleteRecord: (record) ->
    index = @state.records.indexOf record
    records = React.addons.update(@state.records, { $splice: [[index, 1]] })
    @replaceState records: records

  # Update record
  updateRecord: (record, data) ->
    index = @state.records.indexOf record
    records = React.addons.update(@state.records, { $splice: [[index, 1, data]] })
    @replaceState records: records


  # Logique de calcul des montants
  credits: ->
    credits = @state.records.filter (val) -> val.amount >= 0
    credits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  debits: ->
    debits = @state.records.filter (val) -> val.amount < 0
    debits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  balance: ->
    @debits() + @credits()


  render: ->
    React.DOM.div
      className: 'records'
      React.DOM.h2
        className: 'title'
        'Records'
      # Box indication montant credit, balance,...
      React.DOM.div
          className: 'row'
          React.createElement AmountBox, type: 'success', amount: @credits(), text: 'Credit'
          React.createElement AmountBox, type: 'info', amount: @balance(), text: 'Balance'
          React.createElement AmountBox, type: 'danger', amount: @debits(), text: 'Debit'
      React.DOM.hr null
      # Table display chaque record
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          # Labels
          React.DOM.tr null,
            React.DOM.th null, 'Date'
            React.DOM.th null, 'Title'
            React.DOM.th null, 'Amount'
            React.DOM.th null, 'Actions'
        # Parcours le tableau des records et dit quoi afficher
        React.DOM.tbody null,
          for record in @state.records
            React.createElement Record, key: record.id, record: record, handleDeleteRecord: @deleteRecord, handleEditRecord: @updateRecord
      # Input pour créer un nouveau record
      React.createElement RecordForm, handleNewRecord: @addRecord

