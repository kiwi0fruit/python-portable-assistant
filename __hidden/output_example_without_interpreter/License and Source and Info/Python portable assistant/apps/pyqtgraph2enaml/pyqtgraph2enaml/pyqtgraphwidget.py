# -*- coding: utf-8 -*-
# pyqtgraph PlotWidget

from enaml.widgets.api import RawWidget
from enaml.core.declarative import d_
from atom.api import Typed, set_default
from pyqtgraph import PlotWidget, PlotDataItem
from numpy import ndarray


class PGPlotWidget(RawWidget):
    startData = d_(Typed(ndarray))
    _plot = Typed(PlotDataItem)

    #: expand freely in height and width by default.
    hug_width = set_default('ignore')
    hug_height = set_default('ignore')

    def create_widget(self, parent):
        widget = PlotWidget(parent)
        self._plot = widget.plot(pen='y')
        self._plot.setData(self.startData)
        widget.enableAutoRange('xy', False)
        return widget

    def update(self, data):
        self._plot.setData(data)
