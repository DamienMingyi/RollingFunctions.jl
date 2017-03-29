module RollingFunctions

export AbstractRoller, Roller, Runner, 
       RollFullSpans, RollFirstSpans, RollFinalSpans


@compat abstract type AbstractRoller{T} end

@compat struct Roller{T} <: AbstractRoller{T}
    fn::Function
    span::Int64
end

@compat const RollFullSpans  = Roller{Val{:full}}    # use only completely spanned values (shorter result)
@compat const RollFirstSpans = Roller{Val{:first}}   # final values are spanned coarsely  (equilength result, tapiring at end)
@compat const RollFinalSpans = Roller{Val{:final}}   # first values are spanned coarsely  (equilength result, tapiring at start)


struct Runner{T, R} <: AbstractRoller{T}
    roll::Roller{T}
end

function Runner{T,R}(roll::RollFullSpans, data::Vector{R})
    rolling(roll.fn, roll.span, data)
end

function Runner{T,R}(roll::RollFirstValue, data::Vector{R})
    rolling_start(roll.fn, roll.span, data)
end

function Runner{T,R}(roll::RollFinalValue, data::Vector{R})
    rolling_finish(roll.fn, roll.span, data)
end


include("rolling.jl")


end # module
