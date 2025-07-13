using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;

namespace ClimbLog.Infrastructure.Repositories;
public class DifficultiesForGradeRepository(ClimbLogContext dbContext) : IDifficultiesForGradeRepository
{
    public async Task<DifficultyForGrade> GetDifficultyForGradeByNumber(int number)
    {
        var result = await dbContext.DifficultiesForGrade.Where(x => x.Number == number).SingleAsync();

        return result;
    }
}
