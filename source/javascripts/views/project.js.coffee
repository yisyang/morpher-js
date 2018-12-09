class Gui.Views.Project extends Backbone.View
  className: 'project'

  menuTemplate: JST["templates/project_menu"]
  menuEl: null

  blendFunctionView: null
  finalTouchFunctionView: null

  imageViews: null
  previewView: null

  selectedPoints: null

  initialize: =>
    @$menuEl = $('<div />').addClass('project-menu')
    @menuEl = @$menuEl[0]
    @$menuEl.on 'click', '[data-action]', @clickHandler

    @blendFunctionView = new Gui.Views.Popups.EditFunction(model: @model, name: 'blend_function')
    @finalTouchFunctionView = new Gui.Views.Popups.EditFunction(model: @model, name: 'final_touch_function')

    @model.morpher.on "resize", @updateImagesSize
    @model.morpher.on "load", @loadHandler

#    @previewView = new Gui.Views.Tile()

    @selectedPoints = []
    
    @imageViews = []
    @model.images.bind 'add', @addImageView
    @model.images.bind 'reset', @addAllImageViews
    @model.images.bind 'remove', @removeImageView


  # public methods

  save: =>
    @model.save()

  show: =>
    @$menuEl.addClass('visible')
    @$el.addClass('visible')

  hide: =>
    @$menuEl.removeClass('visible')
    @$el.removeClass('visible')

  remove: =>
    @$menuEl.remove()
    super

  export: =>
    popup = Gui.Views.Popup.show("templates/popups/code", code: @model.getCode())
    popup.$el.find('textarea.code').focus().select()

  addPlaceholderPoints: =>
    @model.morpher.fromJSON({
      "images": [
        {
          "points": [
            { "x": 0, "y": 0 }, { "x": 125, "y": 0 }, { "x": 250, "y": 0 }, { "x": 375, "y": 0 }, { "x": 500, "y": 0 }, { "x": 625, "y": 0 }, { "x": 750, "y": 0 }, { "x": 875, "y": 0 }, { "x": 1000, "y": 0 },
            { "x": 0, "y": 125 }, { "x": 500, "y": 500 }, { "x": 550, "y": 500 }, { "x": 600, "y": 500 }, { "x": 650, "y": 500 }, { "x": 700, "y": 500 }, { "x": 750, "y": 500 }, { "x": 800, "y": 500 }, { "x": 1000, "y": 125 },
            { "x": 0, "y": 250 }, { "x": 500, "y": 550 }, { "x": 550, "y": 550 }, { "x": 600, "y": 550 }, { "x": 650, "y": 550 }, { "x": 700, "y": 550 }, { "x": 750, "y": 550 }, { "x": 800, "y": 550 }, { "x": 1000, "y": 250 },
            { "x": 0, "y": 375 }, { "x": 500, "y": 600 }, { "x": 550, "y": 600 }, { "x": 600, "y": 600 }, { "x": 650, "y": 600 }, { "x": 700, "y": 600 }, { "x": 750, "y": 600 }, { "x": 800, "y": 600 }, { "x": 1000, "y": 375 },
            { "x": 0, "y": 500 }, { "x": 500, "y": 650 }, { "x": 550, "y": 650 }, { "x": 600, "y": 650 }, { "x": 650, "y": 650 }, { "x": 700, "y": 650 }, { "x": 750, "y": 650 }, { "x": 800, "y": 650 }, { "x": 1000, "y": 500 },
            { "x": 0, "y": 625 }, { "x": 500, "y": 700 }, { "x": 550, "y": 700 }, { "x": 600, "y": 700 }, { "x": 650, "y": 700 }, { "x": 700, "y": 700 }, { "x": 750, "y": 700 }, { "x": 800, "y": 700 }, { "x": 1000, "y": 625 },
            { "x": 0, "y": 750 }, { "x": 500, "y": 750 }, { "x": 550, "y": 750 }, { "x": 600, "y": 750 }, { "x": 650, "y": 750 }, { "x": 700, "y": 750 }, { "x": 750, "y": 750 }, { "x": 800, "y": 750 }, { "x": 1000, "y": 750 },
            { "x": 0, "y": 875 }, { "x": 500, "y": 800 }, { "x": 550, "y": 800 }, { "x": 600, "y": 800 }, { "x": 650, "y": 800 }, { "x": 700, "y": 800 }, { "x": 750, "y": 800 }, { "x": 800, "y": 800 }, { "x": 1000, "y": 875 },
            { "x": 0, "y": 1000 }, { "x": 125, "y": 1000 }, { "x": 250, "y": 1000 }, { "x": 375, "y": 1000 }, { "x": 500, "y": 1000 }, { "x": 625, "y": 1000 }, { "x": 750, "y": 1000 }, { "x": 875, "y": 1000 }, { "x": 1000, "y": 1000 }
          ]
        },
        {
          "points": [
            { "x": 450, "y": 450 }, { "x": 500, "y": 450 }, { "x": 550, "y": 450 }, { "x": 600, "y": 450 }, { "x": 650, "y": 450 }, { "x": 700, "y": 450 }, { "x": 750, "y": 450 }, { "x": 800, "y": 450 }, { "x": 850, "y": 450 },
            { "x": 450, "y": 500 }, { "x": 500, "y": 500 }, { "x": 550, "y": 500 }, { "x": 600, "y": 500 }, { "x": 650, "y": 500 }, { "x": 700, "y": 500 }, { "x": 750, "y": 500 }, { "x": 800, "y": 500 }, { "x": 850, "y": 500 },
            { "x": 450, "y": 550 }, { "x": 500, "y": 550 }, { "x": 550, "y": 550 }, { "x": 600, "y": 550 }, { "x": 650, "y": 550 }, { "x": 700, "y": 550 }, { "x": 750, "y": 550 }, { "x": 800, "y": 550 }, { "x": 850, "y": 550 },
            { "x": 450, "y": 600 }, { "x": 500, "y": 600 }, { "x": 550, "y": 600 }, { "x": 600, "y": 600 }, { "x": 650, "y": 600 }, { "x": 700, "y": 600 }, { "x": 750, "y": 600 }, { "x": 800, "y": 600 }, { "x": 850, "y": 600 },
            { "x": 450, "y": 650 }, { "x": 500, "y": 650 }, { "x": 550, "y": 650 }, { "x": 600, "y": 650 }, { "x": 650, "y": 650 }, { "x": 700, "y": 650 }, { "x": 750, "y": 650 }, { "x": 800, "y": 650 }, { "x": 850, "y": 650 },
            { "x": 450, "y": 700 }, { "x": 500, "y": 700 }, { "x": 550, "y": 700 }, { "x": 600, "y": 700 }, { "x": 650, "y": 700 }, { "x": 700, "y": 700 }, { "x": 750, "y": 700 }, { "x": 800, "y": 700 }, { "x": 850, "y": 700 },
            { "x": 450, "y": 750 }, { "x": 500, "y": 750 }, { "x": 550, "y": 750 }, { "x": 600, "y": 750 }, { "x": 650, "y": 750 }, { "x": 700, "y": 750 }, { "x": 750, "y": 750 }, { "x": 800, "y": 750 }, { "x": 850, "y": 750 },
            { "x": 450, "y": 800 }, { "x": 500, "y": 800 }, { "x": 550, "y": 800 }, { "x": 600, "y": 800 }, { "x": 650, "y": 800 }, { "x": 700, "y": 800 }, { "x": 750, "y": 800 }, { "x": 800, "y": 800 }, { "x": 850, "y": 800 },
            { "x": 450, "y": 850 }, { "x": 500, "y": 850 }, { "x": 550, "y": 850 }, { "x": 600, "y": 850 }, { "x": 650, "y": 850 }, { "x": 700, "y": 850 }, { "x": 750, "y": 850 }, { "x": 800, "y": 850 }, { "x": 850, "y": 850 }
          ]
        }
      ],
      "triangles": [
        [0, 1, 9], [1, 10, 9], [1, 2, 10], [2, 11, 10], [2, 3, 11], [3, 12, 11], [3, 4, 12], [4, 13, 12], [4, 5, 13], [5, 14, 13], [5, 6, 14], [6, 15, 14], [6, 7, 15], [7, 16, 15], [7, 8, 16], [8, 17, 16],
        [9, 10, 18], [10, 19, 18], [10, 11, 19], [11, 20, 19], [11, 12, 20], [12, 21, 20], [12, 13, 21], [13, 22, 21], [13, 14, 22], [14, 23, 22], [14, 15, 23], [15, 24, 23], [15, 16, 24], [16, 25, 24], [16, 17, 25], [17, 26, 25],
        [18, 19, 27], [19, 28, 27], [19, 20, 28], [20, 29, 28], [20, 21, 29], [21, 30, 29], [21, 22, 30], [22, 31, 30], [22, 23, 31], [23, 32, 31], [23, 24, 32], [24, 33, 32], [24, 25, 33], [25, 34, 33], [25, 26, 34], [26, 35, 34],
        [27, 28, 36], [28, 37, 36], [28, 29, 37], [29, 38, 37], [29, 30, 38], [30, 39, 38], [30, 31, 39], [31, 40, 39], [31, 32, 40], [32, 41, 40], [32, 33, 41], [33, 42, 41], [33, 34, 42], [34, 43, 42], [34, 35, 43], [35, 44, 43],
        [36, 37, 45], [37, 46, 45], [37, 38, 46], [38, 47, 46], [38, 39, 47], [39, 48, 47], [39, 40, 48], [40, 49, 48], [40, 41, 49], [41, 50, 49], [41, 42, 50], [42, 51, 50], [42, 43, 51], [43, 52, 51], [43, 44, 52], [44, 53, 52],
        [45, 46, 54], [46, 55, 54], [46, 47, 55], [47, 56, 55], [47, 48, 56], [48, 57, 56], [48, 49, 57], [49, 58, 57], [49, 50, 58], [50, 59, 58], [50, 51, 59], [51, 60, 59], [51, 52, 60], [52, 61, 60], [52, 53, 61], [53, 62, 61],
        [54, 55, 63], [55, 64, 63], [55, 56, 64], [56, 65, 64], [56, 57, 65], [57, 66, 65], [57, 58, 66], [58, 67, 66], [58, 59, 67], [59, 68, 67], [59, 60, 68], [60, 69, 68], [60, 61, 69], [61, 70, 69], [61, 62, 70], [62, 71, 70],
        [63, 64, 72], [64, 73, 72], [64, 65, 73], [65, 74, 73], [65, 66, 74], [66, 75, 74], [66, 67, 75], [67, 76, 75], [67, 68, 76], [68, 77, 76], [68, 69, 77], [69, 78, 77], [69, 70, 78], [70, 79, 78], [70, 71, 79], [71, 80, 79]
      ]
    })

  editBlendFunction: =>
    Gui.Views.Popup.show @blendFunctionView

  editFinalTouchFunction: =>
    Gui.Views.Popup.show @finalTouchFunctionView


  # image views

  addImage: =>
    @model.images.create()

  addImageView: (image) =>
    imageView = new Gui.Views.Image(model: image)
    @imageViews.push imageView
    imageView.on 'drag:stop', @save
    imageView.on 'highlight', @hightlightHandler
    imageView.on 'select', @selectHandler
    @$el.append imageView.render().el
    @arrangeImages()
    if image.isNew()
      imageView.openFile()

  addAllImageViews: =>
    for view in @imageViews
      view.remove()
    @imageViews = []
    @model.images.each(@addImageView)

  removeImageView: (image, collection, params)=>
    @imageViews[params.index].remove()
    delete @imageViews.splice params.index, 1
    @arrangeImages()

  updateImagesSize: (morpher, canvas) =>
    for image in @imageViews
      image.setSize canvas.width, canvas.height

  arrangeImages: =>
    views = @imageViews.slice 0
#    views.splice views.length/2, 0, @previewView
    count = views.length
    for image, i in views
      image.setPosition i/count, 0, 1/count, 1

  hightlightHandler: (index, state, midpoint = false) =>
    for image in @imageViews
      image.highlightPoint index, state, midpoint

  selectHandler: (index) =>
    i = @selectedPoints.indexOf(index)
    if i != -1
      @selectedPoints.splice i, 1
    else
      @selectedPoints.push index
    if @selectedPoints.length < 3
      for image in @imageViews
        image.selectPoint index, i == -1
    else
      @model.addTriangle @selectedPoints[0], @selectedPoints[1], @selectedPoints[2]
      for image in @imageViews
        for p in @selectedPoints
          image.selectPoint p, false
      @selectedPoints = []


  loadHandler: (morpher, canvas)=>
    @updateImagesSize(morpher, canvas)
  

  clickHandler: (e) =>
    @[$(e.currentTarget).data('action')]()

  render: =>
    @$menuEl.html @menuTemplate()
#    @blendFunctionView.render()
#    @finalTouchFunctionView.render()
#    @previewView.render().$el.appendTo @el
#    @previewView.$pane.append $('<div />').addClass('artboard').append(@model.morpher.canvas)
    @addAllImageViews()
    this
