using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;

public interface IGradesRepository
{
    Task<Grade> GetGradeById(int id);
    Task<List<Grade>> GetGradesByGradeSystemId(int gradeSystemId);
}