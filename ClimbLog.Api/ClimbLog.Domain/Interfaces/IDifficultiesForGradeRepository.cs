using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;
public interface IDifficultiesForGradeRepository
{
    Task<DifficultyForGrade> GetDifficultyForGradeByNumber(int number);
}