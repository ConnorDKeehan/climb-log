using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Infrastructure.Repositories;

public class GradesRepository(ClimbLogContext dbContext) : IGradesRepository
{
    public async Task<List<Grade>> GetGradesByGradeSystemId(int gradeSystemId)
    {
        var gymGrades = await dbContext.Grades.Where(x => x.GradeSystemId == gradeSystemId).ToListAsync();

        return gymGrades;
    }

    public async Task<Grade> GetGradeById(int id) {
        var result = await dbContext.FindAsync<Grade>(id);

        if(result == null)
        {
            throw new KeyNotFoundException($"GradeId {id} doesn't exist");
        }

        return result;
    }
}
