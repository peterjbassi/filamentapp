<?php

namespace App\Filament\Widgets;

use Filament\Widgets\ChartWidget;

class TestF extends ChartWidget
{
    protected static ?string $heading = 'Chart';
    protected static ?string $maxHeight = '100px';
    protected function getData(): array
    {
        return [
            //
        ];
    }

    protected function getType(): string
    {
        return 'bar';
    }
}
