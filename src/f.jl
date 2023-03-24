using WAV, Plots, DSP, PlotlyJS, Statistics, Images, ImageCore

function spectrogram_from_path(path)
    full, fs = wavread(path)
    s = full[1:length(full)]
    # Plots.plot(s)
    windowlength = 0.005
    step = 0.001
    a = convert(Int, windowlength*fs)
    b = convert(Int, round(windowlength - step, digits=3)*fs)
    sp = spectrogram(s[:,1], a, b; window=hanning)
    t = time(sp)
    f = freq(sp)
    ps = power(sp)
    y = 20*log10.(ps)
    y2 = y .- maximum(y)
    y5 = map(y2) do x
        if x < -100
            -100
        else
            x
        end
    end
    y3 = abs.(y5)
    y4 = y3 ./ maximum(y3)
    yy = y4[1:41,:];
    yyy = Gray.(reverse(yy, dims=1));
    new_size = trunc.(Int, (size(yyy)[1] * 10, size(yyy)[2] * 2))
    img_rescaled = imresize(yyy, new_size);
    mosaicview(yyy, img_rescaled; nrow=2)
end
